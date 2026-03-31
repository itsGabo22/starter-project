import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../enums/ai_editor_tone.dart';
import '../repository/journalist_repository.dart';

class EnhanceJournalistTextParams {
  final String text;
  final AiEditorTone tone;

  const EnhanceJournalistTextParams({required this.text, required this.tone});
}

class EnhanceJournalistTextUseCase implements UseCase<DataState<String>, EnhanceJournalistTextParams> {
  final JournalistRepository _journalistRepository;

  EnhanceJournalistTextUseCase(this._journalistRepository);

  @override
  Future<DataState<String>> call({EnhanceJournalistTextParams? params}) {
    return _journalistRepository.enhanceText(params!.text, params.tone);
  }
}
