import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart' as pb;
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:google_speech/google_speech.dart';

class AudioClipTranscriptionService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterFFmpeg _ffmpeg = FlutterFFmpeg();
  late SpeechToText _speechToText;

  Future<void> initialize() async {
    await _preloadFFmpeg();
    await _initializeGoogleSpeechToText();
  }

  Future<void> _preloadFFmpeg() async {
    await _ffmpeg.execute('-version');
    print('FFmpeg preloaded and ready.');
  }

  Future<void> _initializeGoogleSpeechToText() async {
    try {
      final serviceAccountJson = await rootBundle.loadString('assets/credentials/astral-genre-437819-k4-37c42fdaad5d.json');
      final serviceAccount = ServiceAccount.fromString(serviceAccountJson);
      _speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      print('Google Speech-to-Text initialized successfully.');
    } catch (e) {
      print('Error initializing Google Speech-to-Text: $e');
      rethrow;
    }
  }

  Future<String> clipAndTranscribe(String url, Duration start, Duration end) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Load and play the audio clip
      await _audioPlayer.setUrl(url);
      await _audioPlayer.setClip(start: start, end: end);
      await _audioPlayer.setVolume(0.0);  // Mute playback
      await _audioPlayer.play();
      await Future.delayed(end - start);  // Wait for the duration of the clip
      await _audioPlayer.stop();

      print('Clipping audio...');
      final Uint8List clippedAudioData = await _getClippedAudioData(url, start, end);

      print('Recognizing audio from file...');
      final transcription = await _recognizeAudioFromFile(clippedAudioData);
      
      print('Transcription completed.');
      return transcription;
    } catch (e) {
      print('Error during audio processing: $e');
      return "";
    }
  }

  Future<String> _recognizeAudioFromFile(Uint8List audioData) async {
    final config = _getConfig();
    final audioContent = await _getAudioContent(audioData);
    final response = await _speechToText.recognize(config, audioContent);
    if (response.results.isNotEmpty) {
      return response.results.map((result) => result.alternatives.first.transcript).join('\n');
    }
    return '';
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US');

  Future<List<int>> _getAudioContent(Uint8List audioData) async {
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/temp_audio.wav';
    await File(path).writeAsBytes(audioData);
    return File(path).readAsBytesSync().toList();
  }

  Future<Uint8List> _getClippedAudioData(String url, Duration start, Duration end) async {
    final tempDir = await getTemporaryDirectory();
    final inputFilePath = '${tempDir.path}/input.mp3';
    final outputFilePath = '${tempDir.path}/clipped.wav';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load audio from network');
    }

    await File(inputFilePath).writeAsBytes(response.bodyBytes);

    if (await File(outputFilePath).exists()) {
      await File(outputFilePath).delete();
    }

    int startSeconds = start.inSeconds;
    int durationSeconds = end.inSeconds - start.inSeconds + 2; // Add a buffer of 2 seconds

    await _ffmpeg.execute(
        '-i $inputFilePath -ss $startSeconds -t $durationSeconds -acodec pcm_s16le -ar 16000 -ac 1 $outputFilePath');

    return await File(outputFilePath).readAsBytes();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
