import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import 'package:news_app_clean_architecture/config/theme/bloc/theme_cubit.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPage();
  }

  _buildAppbar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        'Daily News',
        style: theme.appBarTheme.titleTextStyle,
      ),
      actions: [
        // ── Theme selection menu ──
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return PopupMenuButton<AppThemeMode>(
              icon: Icon(
                themeState.themeMode == AppThemeMode.dark
                    ? Icons.dark_mode_rounded
                    : (themeState.themeMode == AppThemeMode.newspaper
                        ? Icons.menu_book_rounded
                        : Icons.light_mode_rounded),
                color: themeState.themeMode == AppThemeMode.newspaper 
                    ? AppColors.newspaperAccent 
                    : AppColors.warning,
              ),
              onSelected: (mode) => context.read<ThemeCubit>().setTheme(mode),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: AppThemeMode.light,
                  child: Row(
                    children: [
                      Icon(Icons.light_mode_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Light Mode'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: AppThemeMode.dark,
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Dark Mode'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: AppThemeMode.newspaper,
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_rounded, size: 20),
                      SizedBox(width: 12),
                      Text('Newspaper Mode (Classic)'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        GestureDetector(
          onTap: () => _onShowSavedArticlesViewTapped(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Icon(Icons.bookmark,
                color: theme.appBarTheme.iconTheme?.color),
          ),
        ),
      ],
    );
  }

  _buildPage() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return Scaffold(
              appBar: _buildAppbar(context),
              body: const Center(child: CupertinoActivityIndicator()));
        }
        if (state is RemoteArticlesError) {
          return Scaffold(
              appBar: _buildAppbar(context),
              body: const Center(child: Icon(Icons.refresh)));
        }
        if (state is RemoteArticlesDone) {
          return _buildArticlesPage(context, state.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesPage(
      BuildContext context, List<ArticleEntity> articles) {
    List<Widget> articleWidgets = [];
    for (var article in articles) {
      articleWidgets.add(ArticleWidget(
        article: article,
        onArticlePressed: (article) => _onArticlePressed(context, article),
      ));
    }

    return Scaffold(
      appBar: _buildAppbar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RemoteArticlesBloc>().add(const GetArticles());
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: articleWidgets,
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppColors.fabGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/JournalistDashboard');
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.edit_note_rounded, color: Colors.white),
        ),
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
