import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/usecases/get_ai_chat_response.dart';
import 'ai_chat_event.dart';
import 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final GetAiChatResponse _getAiChatResponse;

  AiChatBloc(this._getAiChatResponse) : super(const AiChatInitial()) {
    on<AiChatStarted>(_onStarted);
    on<AiChatSendMessage>(_onSendMessage);
  }

  void _onStarted(AiChatStarted event, Emitter<AiChatState> emit) {
    emit(const AiChatInitial());
  }

  Future<void> _onSendMessage(
    AiChatSendMessage event,
    Emitter<AiChatState> emit,
  ) async {
    // Grab existing history safely from current state
    final currentMessages = _getCurrentMessages();

    // 1. Immediately add the user's message to the chat
    final userMessage = ChatMessageEntity(
      text: event.userMessage,
      isFromUser: true,
      timestamp: DateTime.now(),
    );
    final messagesWithUser = List<ChatMessageEntity>.from(currentMessages)
      ..add(userMessage);

    // 2. Emit loading so the UI shows the "Oracle is thinking..." indicator
    emit(AiChatLoading(messages: messagesWithUser));

    try {
      debugPrint('--- [AiChatBloc] Sending to Oracle: "${event.userMessage}" ---');

      // 3. Call the grounded UseCase
      final aiResponse = await _getAiChatResponse(
        userPrompt: event.userMessage,
        articleContext: event.articleContext,
      );

      debugPrint('--- [AiChatBloc] Oracle responded: "${aiResponse.text}" ---');

      // 4. Add AI response and update UI
      final updatedMessages = List<ChatMessageEntity>.from(messagesWithUser)
        ..add(aiResponse);

      emit(AiChatHistoryUpdated(messages: updatedMessages));
    } catch (e) {
      debugPrint('--- [AiChatBloc] ERROR: $e ---');

      // 5. On failure, preserve existing messages and show error
      final errorMessage = ChatMessageEntity(
        text: 'The Oracle is temporarily unavailable. Please try again.',
        isFromUser: false,
        timestamp: DateTime.now(),
      );
      final messagesWithError = List<ChatMessageEntity>.from(messagesWithUser)
        ..add(errorMessage);

      emit(AiChatError(
        message: e.toString(),
        messages: messagesWithError,
      ));
    }
  }

  List<ChatMessageEntity> _getCurrentMessages() {
    final s = state;
    if (s is AiChatHistoryUpdated) return s.messages;
    if (s is AiChatLoading) return s.messages;
    if (s is AiChatError) return s.messages;
    return [];
  }
}
