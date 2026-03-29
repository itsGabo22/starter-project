import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journalist_article.dart';
import '../repository/journalist_repository.dart';

class GetArticlesUseCase implements UseCase<DataState<List<JournalistArticleEntity>>, void> {
  final JournalistRepository _journalistRepository;

  GetArticlesUseCase(this._journalistRepository);

  @override
  Future<DataState<List<JournalistArticleEntity>>> call({void params}) {
    return _journalistRepository.getArticles();
  }
}
