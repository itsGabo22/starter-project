import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import '../../domain/use_cases/get_articles_usecase.dart';
import 'journalist_articles_state.dart';

class JournalistArticlesCubit extends Cubit<JournalistArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;

  JournalistArticlesCubit(this._getArticlesUseCase) : super(const JournalistArticlesLoading());

  Future<void> getArticles() async {
    emit(const JournalistArticlesLoading());

    final dataState = await _getArticlesUseCase();

    if (dataState is DataSuccess && dataState.data != null) {
      emit(JournalistArticlesDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      // Mapping DioError to nullable Exception or similar
      emit(JournalistArticlesError(dataState.error as Exception));
    }
  }
}
