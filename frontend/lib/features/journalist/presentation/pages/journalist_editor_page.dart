import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/journalist_article.dart';
import '../bloc/journalist_editor_cubit.dart';
import '../bloc/journalist_editor_state.dart';

class JournalistEditorPage extends StatefulWidget {
  final JournalistArticleEntity? article;

  const JournalistEditorPage({Key? key, this.article}) : super(key: key);

  @override
  State<JournalistEditorPage> createState() => _JournalistEditorPageState();
}

class _JournalistEditorPageState extends State<JournalistEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  List<String> _tags = [];
  String? _aiSummary;
  String _status = 'draft';
  bool _showWordCount = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title);
    _contentController = TextEditingController(text: widget.article?.content);
    _imageUrlController = TextEditingController(
        text: widget.article?.media?.thumbnailURL ?? '');
    _tags = widget.article?.aiEnhancements?.tags ?? [];
    _aiSummary = widget.article?.aiEnhancements?.aiSummary;
    _status = widget.article?.metadata?.status ?? 'draft';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JournalistEditorCubit>(
      create: (context) => sl<JournalistEditorCubit>(),
      child: BlocListener<JournalistEditorCubit, JournalistEditorState>(
        listener: (context, state) {
          if (state is JournalistEditorAiGenerated) {
            setState(() {
              _tags = List<String>.from(state.aiMetadata?['tags'] ?? []);
              _aiSummary = state.aiMetadata?['aiSummary'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('AI Metadata Generated!'),
                  ],
                ),
                backgroundColor: AppColors.accent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
          if (state is JournalistEditorSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white,
                        size: 18),
                    SizedBox(width: 8),
                    Text('Article Saved Successfully!'),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
          if (state is JournalistEditorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppbar(context),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomActions(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(
        widget.article == null ? 'New Article' : 'Edit Article',
        style: theme.appBarTheme.titleTextStyle,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.close_rounded,
            color: theme.appBarTheme.iconTheme?.color),
      ),
      actions: [
        BlocBuilder<JournalistEditorCubit, JournalistEditorState>(
          builder: (context, state) {
            if (state is JournalistEditorSaving) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: CupertinoActivityIndicator(),
              );
            }
            return Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: AppColors.fabGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: state is JournalistEditorGeneratingAI
                    ? null
                    : () => _onSavePressed(context),
                icon: const Icon(Icons.check_rounded, color: Colors.white,
                    size: 22),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image URL field + preview ──
          _buildImageSection(theme),
          const SizedBox(height: 20),

          // ── Editor fields ──
          _buildEditorFields(theme),
          const SizedBox(height: 30),

          // ── AI Enhancements ──
          _buildAiEnhancementsSection(theme),
        ],
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final url = _imageUrlController.text.trim();
    final hasImage = url.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Image preview ──
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: url,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.darkSurface,
                    highlightColor: AppColors.accent.withOpacity(0.3),
                    child: Container(height: 180, color: AppColors.darkSurface),
                  ),
                  errorWidget: (_, __, ___) => _buildPlaceholderBox(isDark),
                )
              : _buildPlaceholderBox(isDark),
        ),
        const SizedBox(height: 10),

        // ── URL input ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _imageUrlController,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Paste cover image URL...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
              border: InputBorder.none,
              icon: const Icon(Icons.link_rounded, size: 18,
                  color: AppColors.accentCyan),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderBox(bool isDark) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 40,
                color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text('Add a cover image',
                style: TextStyle(color: Colors.white.withOpacity(0.5),
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorFields(ThemeData theme) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          style: theme.textTheme.headlineLarge,
          decoration: InputDecoration(
            hintText: 'Headline',
            hintStyle: theme.textTheme.headlineLarge?.copyWith(
                color: theme.textTheme.headlineLarge?.color?.withOpacity(0.3)),
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
        Divider(color: theme.dividerColor),
        TextField(
          controller: _contentController,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Write your story...',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.3)),
            border: InputBorder.none,
          ),
          maxLines: null,
          onChanged: (_) {
            if (_showWordCount) setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildAiEnhancementsSection(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Real glassmorphism OK here because it's fixed, not in a scrolling list
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : AppColors.accent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.accent.withOpacity(0.2)
              : AppColors.accent.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16,
                      color: AppColors.accent),
                  const SizedBox(width: 6),
                  Text('AI ENHANCEMENTS',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.accent)),
                ],
              ),
              BlocBuilder<JournalistEditorCubit, JournalistEditorState>(
                builder: (context, state) {
                  if (state is JournalistEditorGeneratingAI) {
                    return Shimmer.fromColors(
                      baseColor: AppColors.accent,
                      highlightColor: AppColors.accentCyan,
                      child: const Text('Enhancing...',
                          style: TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    );
                  }
                  return TextButton.icon(
                    onPressed: () => _onGenerateAiMetadata(context),
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('Enhance ✨'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.accent),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_aiSummary != null) ...[
            Text('Summary',
                style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(_aiSummary!,
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _tags
                .map((tag) => Chip(
                      label: Text('#$tag'),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final wordCount = _contentController.text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final charCount = _contentController.text.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // ── Image button (scroll to top) ──
            IconButton(
              onPressed: () {
                // Focus image URL field
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Scroll up to add a cover image URL'),
                    backgroundColor: AppColors.accentCyan,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(Icons.image_outlined,
                  color: AppColors.accentCyan, size: 22),
            ),

            // ── Word counter toggle ──
            IconButton(
              onPressed: () => setState(() => _showWordCount = !_showWordCount),
              icon: Icon(Icons.text_fields_rounded,
                  color: _showWordCount ? AppColors.accent : theme.textTheme.bodyMedium?.color,
                  size: 22),
            ),

            if (_showWordCount) ...[
              const SizedBox(width: 4),
              Text(
                '$wordCount words · $charCount chars',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
            ],

            const Spacer(),

            // ── Status chip (interactive) ──
            GestureDetector(
              onTap: () {
                setState(() {
                  _status = _status == 'draft' ? 'published' : 'draft';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _status == 'published'
                      ? AppColors.success.withOpacity(0.15)
                      : AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _status == 'published'
                        ? AppColors.success.withOpacity(0.5)
                        : AppColors.warning.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  _status == 'published' ? 'Published' : 'Draft',
                  style: TextStyle(
                    color: _status == 'published'
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onGenerateAiMetadata(BuildContext context) {
    if (_contentController.text.isNotEmpty) {
      context
          .read<JournalistEditorCubit>()
          .generateAiMetadata(_contentController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Write some content first!'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _onSavePressed(BuildContext context) {
    final article = JournalistArticleEntity(
      id: widget.article?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      media: JournalistMediaEntity(
        thumbnailURL: _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : null,
      ),
      aiEnhancements: JournalistAiEnhancementsEntity(
        aiSummary: _aiSummary,
        tags: _tags,
      ),
      metadata: JournalistMetadataEntity(
        status: _status,
        createdAt: widget.article?.metadata?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    context.read<JournalistEditorCubit>().saveArticle(article);
  }
}
