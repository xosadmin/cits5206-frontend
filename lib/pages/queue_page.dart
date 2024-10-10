import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../services/audio_handler.dart';

class QueuePage extends StatefulWidget {
  final PodcastAudioHandler audioHandler;

  const QueuePage({Key? key, required this.audioHandler}) : super(key: key);

  @override
  _QueuePageState createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  List<MediaItem> _queue = [];
  int _currentIndex = -1;
  StreamSubscription<List<MediaItem>>? _queueSubscription;
  StreamSubscription<PlaybackState>? _playbackStateSubscription;

  @override
  void initState() {
    super.initState();
    _queueSubscription = widget.audioHandler.queue.listen((queue) {
      if (mounted) {
        setState(() {
          _queue = queue;
        });
      }
    });
    _playbackStateSubscription =
        widget.audioHandler.playbackState.listen((playbackState) {
      if (mounted) {
        setState(() {
          _currentIndex = playbackState.queueIndex ?? -1;
        });
      }
    });
  }

  @override
  void dispose() {
    _queueSubscription?.cancel();
    _playbackStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MediaItem> previousItems = _queue.sublist(0, _currentIndex);
    MediaItem? nowPlaying = _currentIndex >= 0 && _currentIndex < _queue.length
        ? _queue[_currentIndex]
        : null;
    List<MediaItem> nextItems = _currentIndex < _queue.length - 1
        ? _queue.sublist(_currentIndex + 1)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Queue'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => _showClearAllDialog(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          if (nowPlaying != null) ...[
            _buildSectionHeader('Now Playing'),
            _buildMediaItemTile(nowPlaying, _currentIndex),
          ],
          if (previousItems.isNotEmpty) ...[
            _buildSectionHeader('Previous in Queue'),
            ...previousItems
                .asMap()
                .entries
                .map((entry) => _buildMediaItemTile(entry.value, entry.key))
                .toList()
                .reversed,
          ],
          if (nextItems.isNotEmpty) ...[
            _buildSectionHeader('Next in Queue'),
            ReorderableListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: nextItems
                  .asMap()
                  .entries
                  .map((entry) => _buildReorderableMediaItemTile(
                      entry.value, _currentIndex + 1 + entry.key))
                  .toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = nextItems.removeAt(oldIndex);
                  nextItems.insert(newIndex, item);

                  // Update the main queue
                  final actualOldIndex = _currentIndex + 1 + oldIndex;
                  final actualNewIndex = _currentIndex + 1 + newIndex;
                  final queueItem = _queue.removeAt(actualOldIndex);
                  _queue.insert(actualNewIndex, queueItem);
                });
                widget.audioHandler.moveQueueItem(
                    _currentIndex + 1 + oldIndex, _currentIndex + 1 + newIndex);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMediaItemTile(MediaItem item, int index) {
    return Dismissible(
      key: ValueKey('dismissible-${item.id}-$index'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          _queue.removeAt(index);
        });
        widget.audioHandler.removeQueueItemAt(index);
      },
      child: ListTile(
        leading: Image.network(item.artUri.toString(), width: 56, height: 56),
        title: Text(item.title),
        subtitle: Text(item.artist ?? ''),
        onTap: () async {
          await widget.audioHandler.skipToQueueItem(index);
          await widget.audioHandler.play();
        },
      ),
    );
  }

  Widget _buildReorderableMediaItemTile(MediaItem item, int index) {
    return Dismissible(
      key: ValueKey('dismissible-${item.id}-$index'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          _queue.removeAt(index);
        });
        widget.audioHandler.removeQueueItemAt(index);
      },
      child: ListTile(
        key: ValueKey('tile-${item.id}-$index'),
        leading: Image.network(item.artUri.toString(), width: 56, height: 56),
        title: Text(item.title),
        subtitle: Text(item.artist ?? ''),
        trailing: ReorderableDragStartListener(
          index: index - (_currentIndex + 1),
          child: Icon(Icons.drag_handle),
        ),
        onTap: () async {
          await widget.audioHandler.skipToQueueItem(index);
          await widget.audioHandler.play();
        },
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Queue'),
          content: Text('Are you sure you want to clear the entire queue?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Clear'),
              onPressed: () {
                widget.audioHandler.clearQueue();
                setState(() {
                  _queue.clear();
                  _currentIndex = -1;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
