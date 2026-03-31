import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/journalist/domain/entities/journalist_article.dart';
import 'package:news_app_clean_architecture/features/journalist/domain/repository/journalist_repository.dart';
import 'package:news_app_clean_architecture/features/journalist/domain/use_cases/get_articles_usecase.dart';
import 'package:news_app_clean_architecture/features/journalist/presentation/bloc/journalist_articles_cubit.dart';
import 'package:news_app_clean_architecture/features/journalist/presentation/bloc/journalist_articles_state.dart';
import 'package:news_app_clean_architecture/features/journalist/domain/enums/ai_editor_tone.dart';

class MockJournalistRepository implements JournalistRepository {
  @override
  Future<DataState<List<JournalistArticleEntity>>> getArticles() async {
    return const DataSuccess([]); // Empty list for test
  }
  
  @override
  Future<DataState<Map<String, dynamic>>> generateAiMetadata(String content) async {
    return const DataSuccess({});
  }

  @override
  Future<DataState<void>> saveArticle(JournalistArticleEntity article) async {
    return const DataSuccess(null);
  }

  @override
  Future<DataState<String>> enhanceText(String text, AiEditorTone tone) async {
    return DataSuccess('Enhanced: $text');
  }
}


void main() {
  group('JournalistArticlesCubit', () {
    late JournalistArticlesCubit cubit;
    late GetArticlesUseCase useCase;
    late MockJournalistRepository mockRepo;

    setUp(() {
      mockRepo = MockJournalistRepository();
      useCase = GetArticlesUseCase(mockRepo);
      cubit = JournalistArticlesCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state should be JournalistArticlesLoading', () {
      expect(cubit.state, isA<JournalistArticlesLoading>());
    });

    test('should emit [JournalistArticlesLoading, JournalistArticlesDone] when getting articles successfully', () async {
      // Act & Assert
      final expectedStates = [
        isA<JournalistArticlesLoading>(),
        isA<JournalistArticlesDone>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.getArticles();
    });
  });
}
