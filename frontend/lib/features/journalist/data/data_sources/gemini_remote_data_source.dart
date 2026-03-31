import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/secrets.dart';

abstract class GeminiRemoteDataSource {
  Future<Map<String, dynamic>> generateAiMetadata(String content);
  Future<String> getChatResponse(String prompt);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final Dio _dio;

  GeminiRemoteDataSourceImpl(this._dio);

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  @override
  Future<Map<String, dynamic>> generateAiMetadata(String content) async {
    final prompt =
        "Summarize the following article in maximum 15 to 20 words, and provide EXACTLY 3 relevant tags. Return the result strictly in JSON format matching this schema: {\"aiSummary\": \"The summary text\", \"tags\": [\"tag1\", \"tag2\", \"tag3\"]}. NEVER add markdown blocks. Article: $content";

    final response = await _dio.post(
      '$_baseUrl?key=$GEMINI_API_KEY',
      data: {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      },
    );

    if (response.statusCode == 200) {
      final rawText = response.data['candidates'][0]['content']['parts'][0]
          ['text'] as String;
      // Gently clean potential markdown blocks from AI response
      final cleanJson =
          rawText.replaceAll('```json', '').replaceAll('```', '').trim();
      return json.decode(cleanJson) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to generate AI content. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<String> getChatResponse(String prompt) async {
    final response = await _dio.post(
      '$_baseUrl?key=$GEMINI_API_KEY',
      data: {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      },
    );

    if (response.statusCode == 200) {
      final rawText = response.data['candidates'][0]['content']['parts'][0]
          ['text'] as String;
      // Remove any markdown artifacts the model might add despite instructions
      return rawText
          .replaceAll('**', '')
          .replaceAll('##', '')
          .replaceAll('```', '')
          .trim();
    } else {
      throw Exception('Symmetry Oracle failed. Status: ${response.statusCode}');
    }
  }
}
