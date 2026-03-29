import 'package:dio/dio.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/journalist_article.dart';
import '../../domain/repository/journalist_repository.dart';
import '../data_sources/firestore_journalist_data_source.dart';
import '../data_sources/gemini_remote_data_source.dart';

class FirestoreJournalistRepositoryImpl implements JournalistRepository {
  final FirestoreJournalistDataSource _firestoreDataSource;
  final GeminiRemoteDataSource _geminiDataSource;

  FirestoreJournalistRepositoryImpl(
    this._firestoreDataSource,
    this._geminiDataSource,
  );

  @override
  Future<DataState<List<JournalistArticleEntity>>> getArticles() async {
    try {
      final models = await _firestoreDataSource.getArticles();
      // Models already extend Entity (based on previous architectural check)
      // We return them properly typed as entities
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: 'firestore_getArticles'),
        error: e,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<void>> saveArticle(JournalistArticleEntity article) async {
    try {
      await _firestoreDataSource.saveArticle(article);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: 'firestore_saveArticle'),
        error: e,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> generateAiMetadata(String content) async {
    try {
      final metadata = await _geminiDataSource.generateAiMetadata(content);
      return DataSuccess(metadata);
    } catch (e) {
      return DataFailed(DioException(
        requestOptions: RequestOptions(path: 'gemini_generateAiMetadata'),
        error: e,
        message: e.toString(),
      ));
    }
  }
}
