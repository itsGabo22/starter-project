import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import 'package:news_app_clean_architecture/config/theme/bloc/theme_cubit.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/journalist_article.dart';
import '../bloc/journalist_articles_cubit.dart';
import '../bloc/journalist_articles_state.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/journalist_article_tile.dart';

class JournalistDashboardPage extends StatelessWidget {
  const JournalistDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JournalistArticlesCubit>(
      create: (context) => sl<JournalistArticlesCubit>()..getArticles(),
      child: Builder(
        builder: (context) => Scaffold(
          body: _buildBody(),
          floatingActionButton: _buildPremiumFAB(context),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<JournalistArticlesCubit, JournalistArticlesState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            if (state is JournalistArticlesLoading)
              const SliverFillRemaining(
                child: Center(child: CupertinoActivityIndicator()),
              ),
            if (state is JournalistArticlesError)
              SliverFillRemaining(
                child: _buildErrorState(context),
              ),
            if (state is JournalistArticlesDone)
              state.articles!.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState(context))
                  : _buildArticlesList(state.articles!),
          ],
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetIcon;
    if (hour < 12) {
      greeting = 'Good Morning';
      greetIcon = Icons.wb_sunny_outlined;
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
      greetIcon = Icons.wb_cloudy_outlined;
    } else {
      greeting = 'Good Evening';
      greetIcon = Icons.nightlight_round_outlined;
    }

    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.chevron_left, color: theme.appBarTheme.iconTheme?.color),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // ── Theme toggle ──
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) =>
                    RotationTransition(turns: anim, child: child),
                child: Icon(
                  themeState.themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(themeState.themeMode),
                  color: AppColors.warning,
                ),
              ),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(greetIcon, size: 14, color: AppColors.warning),
                const SizedBox(width: 6),
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Journalist Mode ✍️',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesList(List<JournalistArticleEntity> articles) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnimatedListItem(
              index: index,
              child: JournalistArticleWidget(
                article: articles[index],
                onArticlePressed: (article) =>
                    _onEditArticlePressed(context, article: article),
              ),
            );
          },
          childCount: articles.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.heroGradient,
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No articles yet',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to write your first story\npowered by AI ✨',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Something went wrong', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () =>
                context.read<JournalistArticlesCubit>().getArticles(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFAB(BuildContext context) {
    return Container(
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
        onPressed: () => _onEditArticlePressed(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _onEditArticlePressed(BuildContext context,
      {JournalistArticleEntity? article}) async {
    await Navigator.pushNamed(context, '/JournalistEditor',
        arguments: article);
    if (context.mounted) {
      context.read<JournalistArticlesCubit>().getArticles();
    }
  }
}
