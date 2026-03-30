import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import 'package:news_app_clean_architecture/core/util/reading_time_helper.dart';
import '../../domain/entities/article.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  final bool? isRemovable;
  final void Function(ArticleEntity article)? onRemove;
  final void Function(ArticleEntity article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isNewspaper = theme.scaffoldBackgroundColor == AppColors.newspaperScaffold;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 0, top: 0),
        height: MediaQuery.of(context).size.width / 2.1,
        decoration: BoxDecoration(
          border: isNewspaper 
              ? Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5))
              : null,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: isNewspaper ? 12 : 7),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : (isNewspaper ? Colors.transparent : Colors.white),
            borderRadius: BorderRadius.circular(isNewspaper ? 0 : 16),
            border: isNewspaper ? null : Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.grey.withOpacity(0.12),
            ),
            boxShadow: (isNewspaper || isDark) ? null : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(isNewspaper ? 0 : 10),
          child: Row(
            children: [
              _buildImage(context, isNewspaper),
              _buildTitleAndDescription(theme, isNewspaper),
              _buildRemovableArea(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, bool isNewspaper) {
    Widget image = CachedNetworkImage(
        imageUrl: article!.urlToImage ?? '',
        imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isNewspaper ? 0 : 14.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
              ),
            ),
        progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isNewspaper ? 0 : 14.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                  ),
                  child: const CupertinoActivityIndicator(),
                ),
              ),
            ),
        errorWidget: (context, url, error) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isNewspaper ? 0 : 14.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                  ),
                  child: Icon(Icons.image_not_supported_outlined,
                      color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ));

    if (isNewspaper) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: image,
      );
    }
    return image;
  }

  Widget _buildTitleAndDescription(ThemeData theme, bool isNewspaper) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isNewspaper ? 0 : 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article!.isExclusive == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: isNewspaper ? null : AppColors.fabGradient,
                    color: isNewspaper ? theme.colorScheme.primary : null,
                    borderRadius: BorderRadius.circular(isNewspaper ? 0 : 4),
                  ),
                  child: Text(
                    'SYMMETRY EXCLUSIVE ⚡',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontFamily: isNewspaper ? 'Serif' : null,
                    ),
                  ),
                ),
              ),
            // Title
            Text(
              article!.title ?? '',
              maxLines: article!.isExclusive == true ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                decoration: isNewspaper ? TextDecoration.underline : null,
                decorationThickness: 0.5,
              ),
            ),

            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article!.description ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),

            // Datetime & Reading Time
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14,
                    color: theme.textTheme.bodyMedium?.color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${article?.publishedAt ?? ''} · ${ReadingTimeHelper.calculateReadingTime(article?.content)} min read',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea(ThemeData theme) {
    if (isRemovable!) {
      return GestureDetector(
        onTap: _onRemove,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.remove_circle_outline, color: AppColors.error),
        ),
      );
    }
    return Container();
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed!(article!);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove!(article!);
    }
  }
}
