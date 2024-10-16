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
    MediaItem? nowPlaying = _currentIndex >= 0 && _currentIndex < _queue.length
        ? _queue[_currentIndex]
        : null;
    List<MediaItem> upNext = _currentIndex < _queue.length - 1
        ? _queue.sublist(_currentIndex + 1)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Queue', style: TextStyle(fontSize: 18, color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all, color: Colors.black),
            onPressed: () => _showClearAllDialog(context),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          if (nowPlaying != null) ...[
            _buildSectionHeader('Now Playing'),
            _buildMediaItemTile(nowPlaying, _currentIndex),
          ],
          if (upNext.isNotEmpty) ...[
            _buildSectionHeader('Up Next'),
            ReorderableListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: upNext
                  .asMap()
                  .entries
                  .map((entry) => _buildReorderableMediaItemTile(
                      entry.value, _currentIndex + 1 + entry.key))
                  .toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = upNext.removeAt(oldIndex);
                  upNext.insert(newIndex, item);

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
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
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
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(item.artUri.toString(), width: 56, height: 56),
        ),
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${item.artist ?? ''} • ${_formatDuration(item.duration)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReorderableDragStartListener(
              index: index - (_currentIndex + 1),
              child: Icon(Icons.drag_handle, color: Colors.grey),
            ),
            SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(item.artUri.toString(), width: 56, height: 56),
            ),
          ],
        ),
        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${item.artist ?? ''} • ${_formatDuration(item.duration)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () async {
          await widget.audioHandler.skipToQueueItem(index);
          await widget.audioHandler.play();
        },
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${duration.inHours}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
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