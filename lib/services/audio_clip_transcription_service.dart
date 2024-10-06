import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AudioClipTranscriptionService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();
  Interpreter? _interpreter;

  Future<void> preload() async {
    await _preloadFFmpeg();
    await _loadTFLiteModel();
  }

  Future<void> _preloadFFmpeg() async {
    await _ffmpeg.execute('-version');
    print('FFmpeg preloaded and ready.');
  }

  Future<void> _loadTFLiteModel() async {
    try {
      final modelFile = await _getModelFile();
      _interpreter = Interpreter.fromFile(modelFile);
      print('TFLite model loaded successfully.');
    } catch (e) {
      print('Error loading TFLite model: $e');
    }
  }

  Future<File> _getModelFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/conformer_model.tflite');

    if (!await modelFile.exists()) {
      final modelBytes =
          await rootBundle.load('assets/models/conformer_model.tflite');
      await modelFile.writeAsBytes(modelBytes.buffer.asUint8List());
    }

    return modelFile;
  }

  Future<String> clipAndTranscribe(
      String url, Duration start, Duration end) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      await _audioPlayer.setUrl(url);
      await _audioPlayer.setClip(start: start, end: end);

      await _audioPlayer.setVolume(0.0);
      await _audioPlayer.play();
      await Future.delayed(end - start);
      await _audioPlayer.stop();

      final Uint8List clippedAudioData =
          await _getClippedAudioData(url, start, end);
      return await _transcribeClipWithTFLite(clippedAudioData);
    } catch (e) {
      print('Error during audio processing: $e');
      return 'Transcription failed';
    }
  }

  Future<String> _transcribeClipWithTFLite(Uint8List audioData) async {
    if (_interpreter == null) {
      await _loadTFLiteModel();
    }

    if (_interpreter == null) {
      throw Exception('Failed to load TFLite model');
    }

    List<double> processedAudio = _preprocessAudio(audioData);

    _interpreter!.resizeInputTensor(0, [1, processedAudio.length]);
    _interpreter!.allocateTensors();

    var input = [processedAudio];
    var intInput = [0];
    var stateInput =
        List.generate(1 * 2 * 1 * 320, (_) => 0.0).reshape([1, 2, 1, 320]);
    var output = List.filled(1000, 0).reshape([1, 1000]);

    _interpreter!
        .runForMultipleInputs([input, intInput, stateInput], {0: output});

    String transcription = _postProcessOutput(output[0]);

    return transcription;
  }

  List<double> _preprocessAudio(Uint8List audioData) {
    return audioData.map((e) => e.toDouble() / 255.0).toList();
  }

  String _postProcessOutput(List<dynamic> output) {
    return String.fromCharCodes(output.map((u) => u.toInt()));
  }

  Future<Uint8List> _getClippedAudioData(
      String url, Duration start, Duration end) async {
    final tempDir = await getTemporaryDirectory();
    final inputFilePath = '${tempDir.path}/input.mp3';
    final outputFilePath = '${tempDir.path}/clipped.wav';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load audio from network');
    }

    await File(inputFilePath).writeAsBytes(response.bodyBytes);

    int startSeconds = start.inSeconds;
    int durationSeconds = end.inSeconds - start.inSeconds;

    await _ffmpeg.execute(
        '-i $inputFilePath -ss $startSeconds -t $durationSeconds -acodec pcm_s16le -ar 16000 $outputFilePath');

    return await File(outputFilePath).readAsBytes();
  }

  void dispose() {
    _audioPlayer.dispose();
    _interpreter?.close();
  }
}
