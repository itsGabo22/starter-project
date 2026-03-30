import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/journalist_repository.dart';

class GenerateAiMetadataUseCase implements UseCase<DataState<Map<String, dynamic>>, String> {
  final JournalistRepository _journalistRepository;

  GenerateAiMetadataUseCase(this._journalistRepository);

  @override
  Future<DataState<Map<String, dynamic>>> call({String? params}) {
    return _journalistRepository.generateAiMetadata(params!);
  }
}
