import 'package:equatable/equatable.dart';

abstract class JournalistEditorState extends Equatable {
  final Map<String, dynamic>? aiMetadata;
  final Exception? error;

  const JournalistEditorState({this.aiMetadata, this.error});

  @override
  List<Object?> get props => [aiMetadata, error];
}

class JournalistEditorInitial extends JournalistEditorState {
  const JournalistEditorInitial();
}

class JournalistEditorGeneratingAI extends JournalistEditorState {
  const JournalistEditorGeneratingAI();
}

class JournalistEditorAiGenerated extends JournalistEditorState {
  const JournalistEditorAiGenerated(Map<String, dynamic> aiMetadata) : super(aiMetadata: aiMetadata);
}

class JournalistEditorSaving extends JournalistEditorState {
  const JournalistEditorSaving();
}

class JournalistEditorSuccess extends JournalistEditorState {
  const JournalistEditorSuccess();
}

class JournalistEditorError extends JournalistEditorState {
  const JournalistEditorError(Exception error) : super(error: error);
}

class JournalistEditorEnhancingText extends JournalistEditorState {
  const JournalistEditorEnhancingText();
}

class JournalistEditorTextEnhanced extends JournalistEditorState {
  final String enhancedText;
  const JournalistEditorTextEnhanced(this.enhancedText);

  @override
  List<Object?> get props => [enhancedText];
}
