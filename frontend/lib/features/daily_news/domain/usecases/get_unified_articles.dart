import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/core/usecase/usecase.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/journalist/domain/repository/journalist_repository.dart';

class GetUnifiedArticlesUseCase implements UseCase<DataState<List<ArticleEntity>>, void> {
  final ArticleRepository _articleRepository;
  final JournalistRepository _journalistRepository;

  GetUnifiedArticlesUseCase(this._articleRepository, this._journalistRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({void params}) async {
    // 1. Fetch from NewsAPI
    final newsApiState = await _articleRepository.getNewsArticles();
    
    // 2. Fetch from Journalist (Firestore)
    final journalistState = await _journalistRepository.getArticles();

    List<ArticleEntity> unifiedList = [];

    // Map Journalist Articles to ArticleEntity (Mapping logic decoupled from entities)
    if (journalistState is DataSuccess && journalistState.data != null) {
      final journalistArticles = journalistState.data!
          .where((a) => a.metadata?.status == 'published') // Only show published
          .map((a) => ArticleEntity(
                author: a.author?.name ?? 'Symmetry Journalist',
                title: a.title,
                description: a.aiEnhancements?.aiSummary ?? a.content,
                url: "", // No external URL for original content
                urlToImage: a.media?.thumbnailURL,
                publishedAt: a.metadata?.publishedAt?.toIso8601String(),
                content: a.content,
                isExclusive: true, // Identify as original content
              ))
          .toList();
      unifiedList.addAll(journalistArticles);
    }

    // Add NewsAPI articles
    if (newsApiState is DataSuccess && newsApiState.data != null) {
      unifiedList.addAll(newsApiState.data!);
    }

    // Sort by date (if possible)
    unifiedList.sort((a, b) {
      final dateA = DateTime.tryParse(a.publishedAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = DateTime.tryParse(b.publishedAt ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA); // Newest first
    });

    if (unifiedList.isNotEmpty) {
      return DataSuccess(unifiedList);
    } else {
      // If both failed or are empty
      if (newsApiState is DataFailed) return DataFailed(newsApiState.error!);
      if (journalistState is DataFailed) return DataFailed(journalistState.error!);
      return const DataSuccess([]);
    }
  }
}
