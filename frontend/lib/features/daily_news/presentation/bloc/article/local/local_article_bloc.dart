import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';

class LocalArticleBloc extends Bloc<LocalArticlesEvent,LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase
  ) : super(const LocalArticlesLoading()){
    on <GetSavedArticles> (onGetSavedArticles);
    on <RemoveArticle> (onRemoveArticle);
    on <SaveArticle> (onSaveArticle);
  }


  void onGetSavedArticles(GetSavedArticles event,Emitter<LocalArticlesState> emit) async {
    try {
      debugPrint("--- [BLoC] Paso 1: Iniciando consulta a base de datos ---");
      final articles = await _getSavedArticleUseCase();
      debugPrint("--- [BLoC] Paso 2: Datos recibidos (${articles.length} artículos) ---");
      emit(LocalArticlesDone(articles));
    } catch (e) {
      debugPrint("--- [BLoC] ERROR en onGetSavedArticles: $e ---");
      emit(const LocalArticlesDone([]));
    }
  }
  
  void onRemoveArticle(RemoveArticle removeArticle,Emitter<LocalArticlesState> emit) async {
    try {
      await _removeArticleUseCase(params: removeArticle.article);
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(const LocalArticlesDone([]));
    }
  }

  void onSaveArticle(SaveArticle saveArticle,Emitter<LocalArticlesState> emit) async {
    try {
      await _saveArticleUseCase(params: saveArticle.article);
      final articles = await _getSavedArticleUseCase();
      emit(LocalArticlesDone(articles));
    } catch (e) {
      emit(const LocalArticlesDone([]));
    }
  }
}