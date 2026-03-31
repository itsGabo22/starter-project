import 'package:flutter/foundation.dart';
import '../entities/chat_message_entity.dart';
import '../repository/ai_chat_repository.dart';

class GetAiChatResponse {
  final AiChatRepository _repository;

  GetAiChatResponse(this._repository);

  Future<ChatMessageEntity> call({
    required String userPrompt,
    required String articleContext,
  }) async {
    // Symmetry Grounding Protocol v2 — Flexible but Grounded
    final groundedPrompt =
        'You are the Symmetry Oracle. You are assisting a user with the following article:\n'
        '"$articleContext"\n\n'
        'Your rules:\n'
        '1. You can answer questions, summarize, explain, or translate THIS article.\n'
        '2. If the user asks about a topic completely unrelated to the article above, '
        'you must reply EXACTLY with: "I cannot find that in the newspaper."\n'
        '3. Be concise and conversational. Do not use markdown formatting.\n\n'
        'User query: $userPrompt';

    debugPrint('--- [Oracle] Context length: ${articleContext.length} chars ---');

    final responseText = await _repository.getChatResponse(
      groundedPrompt,
      articleContext,
    );

    return ChatMessageEntity(
      text: responseText,
      isFromUser: false,
      timestamp: DateTime.now(),
    );
  }
}
