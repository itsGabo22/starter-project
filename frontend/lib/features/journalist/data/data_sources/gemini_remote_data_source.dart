import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/secrets.dart';

abstract class GeminiRemoteDataSource {
  Future<Map<String, dynamic>> generateAiMetadata(String content);
}

class GeminiRemoteDataSourceImpl implements GeminiRemoteDataSource {
  final Dio _dio;

  GeminiRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> generateAiMetadata(String content) async {
    final prompt = "Summarize the following article in maximum 15 to 20 words, and provide EXACTLY 3 relevant tags. Return the result strictly in JSON format matching this schema: {\"aiSummary\": \"The summary text\", \"tags\": [\"tag1\", \"tag2\", \"tag3\"]}. NEVER add markdown blocks. Article: $content";

    final response = await _dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$GEMINI_API_KEY',
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
      final rawText = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
      // Gently clean potential markdown blocks from AI response
      final cleanJson = rawText.replaceAll('```json', '').replaceAll('```', '').trim();
      return json.decode(cleanJson) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to generate AI content. Status code: ${response.statusCode}');
    }
  }
}
