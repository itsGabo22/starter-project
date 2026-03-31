import 'dart:async';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/journalist_article.dart';
import '../../domain/repository/journalist_repository.dart';
import '../../domain/enums/ai_editor_tone.dart';
import '../models/journalist_article_model.dart';

class MockJournalistRepositoryImpl implements JournalistRepository {
  @override
  Future<DataState<List<JournalistArticleEntity>>> getArticles() async {
    // Simulate network delay to demonstrate BLoC loading states later
    await Future.delayed(const Duration(seconds: 1));

    final mockArticles = [
      JournalistArticleModel(
        id: '1',
        title: 'The Future of AI in Journalism',
        content: 'AI is revolutionizing how we write and consume news...',
        author: const JournalistAuthorModel(
          uid: 'user_123',
          name: 'Gabriel Paz',
          avatarUrl: 'https://i.pravatar.cc/150?u=gabriel',
        ),
        media: const JournalistMediaModel(
          thumbnailURL: 'https://images.unsplash.com/photo-1585829365234-781fefc241c4',
        ),
        metadata: JournalistMetadataModel(
          status: 'published',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        aiEnhancements: const JournalistAiEnhancementsModel(
          aiSummary: 'An exploration of AI tools for modern reporters.',
          tags: ['AI', 'Tech', 'Journalism'],
          estimatedReadTime: 5.0,
        ),
      ),
      JournalistArticleModel(
        id: '2',
        title: 'Flutter Cleanup: Master Clean Architecture',
        content: 'Structuring your code is the most important part of any project...',
        author: const JournalistAuthorModel(
          uid: 'user_123',
          name: 'Gabriel Paz',
          avatarUrl: 'https://i.pravatar.cc/150?u=gabriel',
        ),
        media: const JournalistMediaModel(
          thumbnailURL: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
        ),
        metadata: JournalistMetadataModel(
          status: 'draft',
          createdAt: DateTime.now(),
        ),
      ),
    ];

    return DataSuccess(mockArticles);
  }

  @override
  Future<DataState<void>> saveArticle(JournalistArticleEntity article) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a mock implementation, we just return success
    return const DataSuccess(null);
  }

  @override
  Future<DataState<Map<String, dynamic>>> generateAiMetadata(String content) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate AI response
    return const DataSuccess({
      'aiSummary': 'This is a mock AI summary generated for the test.',
      'tags': ['Mock', 'AI', 'Innovation'],
      'estimatedReadTime': 3.5,
    });
  }

  @override
  Future<DataState<String>> enhanceText(String text, AiEditorTone tone) async {
    await Future.delayed(const Duration(seconds: 1));
    return DataSuccess('This is professionally mock-enhanced text applied with tone: ${tone.name}. Previous text was: $text');
  }
}
