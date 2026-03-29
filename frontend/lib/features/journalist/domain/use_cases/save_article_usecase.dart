import '../../../../core/resources/data_state.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/journalist_article.dart';
import '../repository/journalist_repository.dart';

class SaveArticleUseCaseJournalist implements UseCase<DataState<void>, JournalistArticleEntity> {
  final JournalistRepository _journalistRepository;

  SaveArticleUseCaseJournalist(this._journalistRepository);

  @override
  Future<DataState<void>> call({JournalistArticleEntity? params}) {
    // If params is null, we could handle it or return an error state.
    // For now, assuming params is provided.
    return _journalistRepository.saveArticle(params!);
  }
}
