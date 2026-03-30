import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';

// Journalist Feature
import 'features/journalist/data/data_sources/firestore_journalist_data_source.dart';
import 'features/journalist/data/data_sources/gemini_remote_data_source.dart';
import 'features/journalist/data/repository/firestore_journalist_repository_impl.dart';
import 'features/journalist/domain/repository/journalist_repository.dart';
import 'features/journalist/domain/use_cases/generate_ai_metadata_usecase.dart';
import 'features/journalist/domain/use_cases/get_articles_usecase.dart';
import 'features/journalist/domain/use_cases/save_article_usecase.dart';
import 'features/journalist/presentation/bloc/journalist_articles_cubit.dart';
import 'features/journalist/presentation/bloc/journalist_editor_cubit.dart';

import 'features/daily_news/domain/usecases/get_unified_articles.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').fallbackToDestructiveMigration().build();
  sl.registerSingleton<AppDatabase>(database);
  
  // Dio & Firebase
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(),sl())
  );

  sl.registerSingleton<FirestoreJournalistDataSource>(
      FirestoreJournalistDataSourceImpl(sl())
  );

  sl.registerSingleton<GeminiRemoteDataSource>(
      GeminiRemoteDataSourceImpl(sl())
  );

  sl.registerSingleton<JournalistRepository>(
      FirestoreJournalistRepositoryImpl(sl(), sl())
  );
  
  //UseCases
  sl.registerSingleton<GetArticleUseCase>(
    GetArticleUseCase(sl())
  );

  sl.registerSingleton<GetUnifiedArticlesUseCase>(
    GetUnifiedArticlesUseCase(sl(), sl())
  );

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCase>(
    SaveArticleUseCase(sl())
  );
  
  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );

  sl.registerSingleton<GetArticlesUseCase>(
      GetArticlesUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCaseJournalist>(
      SaveArticleUseCaseJournalist(sl())
  );

  sl.registerSingleton<GenerateAiMetadataUseCase>(
      GenerateAiMetadataUseCase(sl())
  );


  //Blocs
  sl.registerFactory<RemoteArticlesBloc>(
    ()=> RemoteArticlesBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    ()=> LocalArticleBloc(sl(),sl(),sl())
  );

  sl.registerFactory<JournalistArticlesCubit>(
      () => JournalistArticlesCubit(sl())
  );

  sl.registerFactory<JournalistEditorCubit>(
      () => JournalistEditorCubit(sl(), sl())
  );


}