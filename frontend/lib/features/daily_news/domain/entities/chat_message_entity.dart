import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [text, isFromUser, timestamp];
}
