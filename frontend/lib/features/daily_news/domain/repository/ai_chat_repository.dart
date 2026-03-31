abstract class AiChatRepository {
  Future<String> getChatResponse(String prompt, String articleContext);
}
