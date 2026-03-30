import 'package:flutter/material.dart';

import '../../features/daily_news/domain/entities/article.dart';
import '../../features/daily_news/presentation/pages/article_detail/article_detail.dart';
import '../../features/daily_news/presentation/pages/home/daily_news.dart';
import '../../features/daily_news/presentation/pages/saved_article/saved_article.dart';
import '../../features/journalist/presentation/screens/journalist_dashboard_page.dart';
import '../../features/journalist/presentation/pages/journalist_editor_page.dart';
import '../../features/journalist/domain/entities/journalist_article.dart';


class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _fadeSlideRoute(const DailyNews(), settings);

      case '/ArticleDetails':
        return _fadeSlideRoute(
            ArticleDetailsView(article: settings.arguments as ArticleEntity), settings);

      case '/SavedArticles':
        return _fadeSlideRoute(const SavedArticles(), settings);

      case '/JournalistDashboard':
        return _fadeSlideRoute(const JournalistDashboardPage(), settings);

      case '/JournalistEditor':
        return _fadeSlideRoute(
            JournalistEditorPage(article: settings.arguments as JournalistArticleEntity?),
            settings);

      default:
        return _fadeSlideRoute(const DailyNews(), settings);
    }
  }

  /// Premium page transition: simultaneous fade + subtle slide-up.
  static Route<dynamic> _fadeSlideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
