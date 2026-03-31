import '../../domain/repository/ai_chat_repository.dart';
import '../../../journalist/data/data_sources/gemini_remote_data_source.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final GeminiRemoteDataSource _geminiDataSource;

  AiChatRepositoryImpl(this._geminiDataSource);

  @override
  Future<String> getChatResponse(String prompt, String articleContext) async {
    // The prompt already contains the grounding instructions from the UseCase.
    // We pass it directly to avoid double-wrapping.
    return _geminiDataSource.getChatResponse(prompt);
  }
}
