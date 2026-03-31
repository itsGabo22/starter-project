enum AiEditorTone {
  polish,
  professional,
  engaging,
  expand
}

extension AiEditorToneExtension on AiEditorTone {
  String get promptValue {
    switch (this) {
      case AiEditorTone.polish:
        return 'polish and correct grammar';
      case AiEditorTone.professional:
        return 'rewrite with a professional/formal tone';
      case AiEditorTone.engaging:
        return 'rewrite with a catchy and engaging tone';
      case AiEditorTone.expand:
        return 'expand and make the text longer';
    }
  }

  String get uiLabel {
    switch (this) {
      case AiEditorTone.polish:
        return '✨ Polish';
      case AiEditorTone.professional:
        return '👔 Professional';
      case AiEditorTone.engaging:
        return '🔥 Engaging';
      case AiEditorTone.expand:
        return '📝 Expand';
    }
  }
}
