import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message_entity.dart';

abstract class AiChatState extends Equatable {
  const AiChatState();

  @override
  List<Object?> get props => [];
}

/// Initial empty state — no messages yet.
class AiChatInitial extends AiChatState {
  const AiChatInitial();
}

/// Oracle is processing the user's question.
class AiChatLoading extends AiChatState {
  final List<ChatMessageEntity> messages;

  const AiChatLoading({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// New message received — UI should rebuild with updated history.
class AiChatHistoryUpdated extends AiChatState {
  final List<ChatMessageEntity> messages;

  const AiChatHistoryUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// API call failed — show error without losing existing history.
class AiChatError extends AiChatState {
  final String message;
  final List<ChatMessageEntity> messages;

  const AiChatError({required this.message, required this.messages});

  @override
  List<Object?> get props => [message, messages];
}
