import 'package:equatable/equatable.dart';
import '../../domain/entities/journalist_article.dart';

abstract class JournalistArticlesState extends Equatable {
  final List<JournalistArticleEntity>? articles;
  final Exception? error;

  const JournalistArticlesState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class JournalistArticlesLoading extends JournalistArticlesState {
  const JournalistArticlesLoading();
}

class JournalistArticlesDone extends JournalistArticlesState {
  const JournalistArticlesDone(List<JournalistArticleEntity> articles) : super(articles: articles);
}

class JournalistArticlesError extends JournalistArticlesState {
  const JournalistArticlesError(Exception error) : super(error: error);
}
