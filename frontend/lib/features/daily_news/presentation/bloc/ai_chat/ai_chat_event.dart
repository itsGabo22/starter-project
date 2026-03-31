import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class AiChatStarted extends AiChatEvent {
  const AiChatStarted();
}

class AiChatSendMessage extends AiChatEvent {
  final String userMessage;
  final String articleContext;

  const AiChatSendMessage({
    required this.userMessage,
    required this.articleContext,
  });

  @override
  List<Object?> get props => [userMessage, articleContext];
}
