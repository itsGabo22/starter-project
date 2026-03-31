import '../../../../core/resources/data_state.dart';
import '../entities/journalist_article.dart';
import '../enums/ai_editor_tone.dart';

abstract class JournalistRepository {
  // Use DataState with List for consistency with the News API pattern
  Future<DataState<List<JournalistArticleEntity>>> getArticles();

  Future<DataState<void>> saveArticle(JournalistArticleEntity article);

  // AI Enhancement Hook - overdelivering from the repository definition
  Future<DataState<Map<String, dynamic>>> generateAiMetadata(String content);

  // Pro Editor: Inline tone adjustment
  Future<DataState<String>> enhanceText(String text, AiEditorTone tone);
}
