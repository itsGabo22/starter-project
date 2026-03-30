import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/journalist_article.dart';
import '../../domain/use_cases/generate_ai_metadata_usecase.dart';
import '../../domain/use_cases/save_article_usecase.dart';
import 'journalist_editor_state.dart';

class JournalistEditorCubit extends Cubit<JournalistEditorState> {
  final SaveArticleUseCaseJournalist _saveArticleUseCase;
  final GenerateAiMetadataUseCase _generateAiMetadataUseCase;

  JournalistEditorCubit(
    this._saveArticleUseCase,
    this._generateAiMetadataUseCase,
  ) : super(const JournalistEditorInitial());

  Future<void> generateAiMetadata(String content) async {
    emit(const JournalistEditorGeneratingAI());

    final dataState = await _generateAiMetadataUseCase(params: content);

    if (dataState is DataSuccess && dataState.data != null) {
      emit(JournalistEditorAiGenerated(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(JournalistEditorError(dataState.error as Exception));
    }
  }

  Future<void> saveArticle(JournalistArticleEntity article) async {
    emit(const JournalistEditorSaving());

    final dataState = await _saveArticleUseCase(params: article);

    if (dataState is DataSuccess) {
      emit(const JournalistEditorSuccess());
    }

    if (dataState is DataFailed) {
      emit(JournalistEditorError(dataState.error as Exception));
    }
  }
}
