import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/journalist_article.dart';
import '../bloc/journalist_articles_cubit.dart';
import '../bloc/journalist_articles_state.dart';
import '../widgets/journalist_article_tile.dart';

class JournalistDashboardPage extends StatelessWidget {
  const JournalistDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JournalistArticlesCubit>(
      create: (context) => sl<JournalistArticlesCubit>()..getArticles(),
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onEditArticlePressed(context),
          child: const Icon(Icons.edit_note, color: Colors.white),
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Journalist Mode',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.chevron_left, color: Colors.black),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<JournalistArticlesCubit, JournalistArticlesState>(
      builder: (context, state) {
        if (state is JournalistArticlesLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is JournalistArticlesError) {
          return const Center(child: Icon(Icons.error_outline));
        }
        if (state is JournalistArticlesDone) {
          return _buildArticleList(state.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticleList(List<JournalistArticleEntity> articles) {
    return ListView.builder(
      itemCount: articles.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        return JournalistArticleWidget(
          article: articles[index],
          onArticlePressed: (article) => _onEditArticlePressed(context, article: article),
        );
      },
    );
  }

  void _onEditArticlePressed(BuildContext context, {JournalistArticleEntity? article}) {
    Navigator.pushNamed(context, '/JournalistEditor', arguments: article);
  }
}
