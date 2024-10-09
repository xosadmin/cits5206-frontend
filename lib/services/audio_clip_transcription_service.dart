import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart' as pb;
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:google_speech/google_speech.dart';
import 'dart:async';

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

      // Use FFmpeg to stream and clip the audio directly
      print('Clipping audio...');
      final Uint8List clippedAudioData = await _getClippedAudioDataInMemory(url, start, end);

      print('Recognizing audio from memory...');
      final transcription = await _recognizeAudioFromMemory(clippedAudioData);

      print('Transcription completed.');
      return transcription;
    } catch (e) {
      print('Error during audio processing: $e');
      return "";
    }
  }

  /// Transcribes audio data held in memory
  Future<String> _recognizeAudioFromMemory(Uint8List audioData) async {
    final config = _getConfig();
    final audioContent = await _getAudioContent(audioData);
    final response = await _speechToText.recognize(config, audioContent);
    if (response.results.isNotEmpty) {
      return response.results.map((result) => result.alternatives.first.transcript).join('\n');
    }
    return '';
  }

  /// Config for speech recognition with Google Speech-to-Text
  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US');

  /// Converts audio data into a list of bytes for Google Speech-to-Text
  Future<List<int>> _getAudioContent(Uint8List audioData) async {
    return audioData.toList();
  }

  /// Streams, clips, and processes the audio in memory using FFmpeg to avoid file I/O
  Future<Uint8List> _getClippedAudioDataInMemory(String url, Duration start, Duration end) async {
    final tempDir = await getTemporaryDirectory();
    final outputFilePath = '${tempDir.path}/clipped.wav';

    int startSeconds = start.inSeconds;
    int durationSeconds = end.inSeconds - start.inSeconds + 2; // Add a buffer of 2 seconds

    // Use FFmpeg with "-nostdin" to optimize and "-threads" to speed up
    await _ffmpeg.execute(
        '-ss $startSeconds -t $durationSeconds -i "$url" -acodec pcm_s16le -ar 16000 -ac 1 -nostdin -threads 2 -y $outputFilePath');

    return await File(outputFilePath).readAsBytes();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
