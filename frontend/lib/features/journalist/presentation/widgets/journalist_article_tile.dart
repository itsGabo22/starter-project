import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import '../../domain/entities/journalist_article.dart';

class JournalistArticleWidget extends StatefulWidget {
  final JournalistArticleEntity? article;
  final void Function(JournalistArticleEntity article)? onArticlePressed;

  const JournalistArticleWidget({
    Key? key,
    this.article,
    this.onArticlePressed,
  }) : super(key: key);

  @override
  State<JournalistArticleWidget> createState() =>
      _JournalistArticleWidgetState();
}

class _JournalistArticleWidgetState extends State<JournalistArticleWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        _onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // Fake glassmorphism – solid semi-transparent for scroll perf
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.accent.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoverImage(context),
                _buildContent(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Cover image – shows article thumbnail or an animated gradient placeholder.
  Widget _buildCoverImage(BuildContext context) {
    final url = widget.article?.media?.thumbnailURL;
    final hasImage = url != null && url.isNotEmpty;

    if (hasImage) {
      return CachedNetworkImage(
        imageUrl: url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => _buildShimmerPlaceholder(),
        errorWidget: (_, __, ___) => _buildGradientPlaceholder(),
      );
    }
    return _buildGradientPlaceholder();
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.darkSurface,
      highlightColor: AppColors.accent.withOpacity(0.3),
      child: Container(height: 180, color: AppColors.darkSurface),
    );
  }

  Widget _buildGradientPlaceholder() {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      child: Center(
        child: Icon(
          Icons.article_outlined,
          size: 48,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  /// Title, status badge, tags, and date.
  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status badge + Date row ──
          Row(
            children: [
              _buildStatusBadge(theme),
              const Spacer(),
              _buildRelativeDate(theme),
            ],
          ),
          const SizedBox(height: 10),

          // ── Title ──
          Text(
            (widget.article!.title?.isNotEmpty == true)
                ? widget.article!.title!
                : 'Untitled Article',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 6),

          // ── AI Summary preview ──
          if (widget.article!.aiEnhancements?.aiSummary != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.article!.aiEnhancements!.aiSummary!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // ── Tags ──
          if (widget.article!.aiEnhancements?.tags != null &&
              widget.article!.aiEnhancements!.tags!.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.article!.aiEnhancements!.tags!
                  .take(3)
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '#$tag',
                          style: const TextStyle(
                            color: AppColors.accentLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final status = widget.article!.metadata?.status ?? 'draft';
    final isPublished = status == 'published';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublished
            ? AppColors.success.withOpacity(0.15)
            : AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPublished
              ? AppColors.success.withOpacity(0.4)
              : AppColors.warning.withOpacity(0.4),
          width: 0.5,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isPublished ? AppColors.success : AppColors.warning,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildRelativeDate(ThemeData theme) {
    final createdAt = widget.article?.metadata?.createdAt;
    if (createdAt == null) return const SizedBox.shrink();

    final diff = DateTime.now().difference(createdAt);
    String relative;
    if (diff.inMinutes < 1) {
      relative = 'Just now';
    } else if (diff.inMinutes < 60) {
      relative = '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      relative = '${diff.inHours}h ago';
    } else {
      relative = '${diff.inDays}d ago';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.access_time_rounded, size: 12,
            color: theme.textTheme.bodyMedium?.color),
        const SizedBox(width: 4),
        Text(relative, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
      ],
    );
  }

  void _onTap() {
    if (widget.onArticlePressed != null) {
      widget.onArticlePressed!(widget.article!);
    }
  }
}
