import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RichTextEditorPage extends StatefulWidget {
  final String initialText;
  static const routeName = '/rich-text-editor';

  const RichTextEditorPage({Key? key, required this.initialText}) : super(key: key);

  @override
  _RichTextEditorPageState createState() => _RichTextEditorPageState();
}

class _RichTextEditorPageState extends State<RichTextEditorPage> {
  late TextEditingController _controller;
  bool _isAutoPreview = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  Future<void> _saveTranscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_transcription', _controller.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transcription saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transcription: $e')),
        );
      }
    }
  }

  Future<void> _loadSavedTranscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedText = prefs.getString('saved_transcription');

      if (savedText != null) {
        setState(() {
          _controller.text = savedText;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loaded saved transcription')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading saved transcription: $e')),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isAutoPreview = !_isAutoPreview;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transcription'),
        actions: [
          IconButton(
            icon: Icon(_isAutoPreview ? Icons.view_agenda : Icons.view_column),
            onPressed: _toggleEditMode,
            tooltip: _isAutoPreview ? 'Switch to Split View' : 'Switch to Auto Preview',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTranscription,
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _loadSavedTranscription,
          ),
        ],
      ),
      body: _isAutoPreview
          ? MarkdownAutoPreview(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Start typing your markdown here...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              emojiConvert: true,
              maxLines: null,
              expands: true,
            )
          : SplittedMarkdownFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Start typing your markdown here...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              emojiConvert: true,
            ),
    );
  }
}
