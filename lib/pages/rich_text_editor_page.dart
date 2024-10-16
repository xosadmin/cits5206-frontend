import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../models/pin.dart';

class RichTextEditorPage extends StatefulWidget {
  final Pin? pin;
  static const routeName = '/rich-text-editor';

  const RichTextEditorPage({super.key, this.pin});

  @override
  _RichTextEditorPageState createState() => _RichTextEditorPageState();
}

class _RichTextEditorPageState extends State<RichTextEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isAutoPreview = true;
  List<String> _tags = [];
  late String _pinId;

  @override
  void initState() {
    super.initState();
    _pinId = widget.pin?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    _titleController = TextEditingController(text: widget.pin?.title ?? '');
    _contentController = TextEditingController(text: widget.pin?.content ?? '');
    _tags = widget.pin?.tags ?? [];
  }

  
  Future<void> _savePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pin = Pin(
        id: _pinId,
        title: _titleController.text,
        content: _contentController.text,
        tags: _tags,
      );
      final pinJson = json.encode(pin.toJson());
      await prefs.setString('pin_$_pinId', pinJson);

      // Update the list of pin IDs
      final pinIds = prefs.getStringList('pin_ids') ?? [];
      if (!pinIds.contains(_pinId)) {
        pinIds.add(_pinId);
        await prefs.setStringList('pin_ids', pinIds);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pin saved successfully!')),
        );
        // Navigate back to PinsPage after saving
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving pin: $e')),
        );
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isAutoPreview = !_isAutoPreview;
    });
  }

  void _insertFormattedText(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final newText = text.replaceRange(selection.start, selection.end,
        '$prefix${selection.textInside(text)}$suffix');
    _contentController.value = _contentController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.start +
              prefix.length +
              selection.textInside(text).length),
    );
  }

  void _insertDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    _insertFormattedText('', formattedDate);
  }

  void _insertCheckbox() {
    _insertFormattedText('- [ ] ', '');
  }

  void _insertCodeBlock() {
    _insertFormattedText('```\n', '\n```');
  }

  Future<void> _insertImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;
      _insertFormattedText('![Alt text](', fileName + ')');
    }
  }

  void _showTagDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTag = '';
        return AlertDialog(
          title: Text('Manage Tags'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTag = value,
                decoration: InputDecoration(hintText: 'Enter new tag'),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Add Tag'),
              onPressed: () {
                if (newTag.isNotEmpty) {
                  setState(() {
                    _tags.add(newTag);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pin'),
        actions: [
          IconButton(
            icon: Icon(_isAutoPreview ? Icons.view_agenda : Icons.view_column),
            onPressed: _toggleEditMode,
            tooltip: _isAutoPreview
                ? 'Switch to Split View'
                : 'Switch to Auto Preview',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePin,
          ),
          IconButton(
            icon: const Icon(Icons.label),
            onPressed: _showTagDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter pin title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.format_bold),
                    onPressed: () => _insertFormattedText('**', '**')),
                IconButton(
                    icon: Icon(Icons.format_italic),
                    onPressed: () => _insertFormattedText('*', '*')),
                IconButton(
                    icon: Icon(Icons.format_strikethrough),
                    onPressed: () => _insertFormattedText('~~', '~~')),
                IconButton(
                    icon: Icon(Icons.format_list_bulleted),
                    onPressed: () => _insertFormattedText('- ', '')),
                IconButton(
                    icon: Icon(Icons.format_list_numbered),
                    onPressed: () => _insertFormattedText('1. ', '')),
                IconButton(
                    icon: Icon(Icons.check_box), onPressed: _insertCheckbox),
                IconButton(icon: Icon(Icons.code), onPressed: _insertCodeBlock),
                IconButton(icon: Icon(Icons.image), onPressed: _insertImage),
                IconButton(
                    icon: Icon(Icons.access_time), onPressed: _insertDateTime),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isAutoPreview
                    ? MarkdownAutoPreview(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          hintText: 'Start typing your markdown here...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        emojiConvert: true,
                        maxLines: null,
                      )
                    : SplittedMarkdownFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          hintText: 'Start typing your markdown here...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        emojiConvert: true,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
