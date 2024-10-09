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
  StreamSubscription<List<MediaItem>>? _queueSubscription;

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
  }

  @override
  Widget build(BuildContext context) {
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
      body: ReorderableListView.builder(
        itemCount: _queue.length,
        itemBuilder: (context, index) {
          final item = _queue[index];
          return Dismissible(
            key: ValueKey('dismissible-${item.id}'),
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
              key: ValueKey('tile-${item.id}'),
              leading:
                  Image.network(item.artUri.toString(), width: 56, height: 56),
              title: Text(item.title),
              subtitle: Text(item.artist ?? ''),
              trailing: ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle),
              ),
              onTap: ()async{
                await widget.audioHandler.playMediaItem(item);
              },
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _queue.removeAt(oldIndex);
            _queue.insert(newIndex, item);
          });
          widget.audioHandler.moveQueueItem(oldIndex, newIndex);
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
