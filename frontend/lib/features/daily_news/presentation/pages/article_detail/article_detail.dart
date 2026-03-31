import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app_clean_architecture/config/theme/app_themes.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';
import '../../bloc/article/local/local_article_state.dart';
import '../../bloc/ai_chat/ai_chat_bloc.dart';
import '../../bloc/ai_chat/ai_chat_event.dart';
import '../../bloc/ai_chat/ai_chat_state.dart';
import 'dart:ui';
import 'package:news_app_clean_architecture/core/util/reading_time_helper.dart';

class ArticleDetailsView extends HookWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({Key? key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Lift the state up! Create the BLoC once for the lifetime of this screen.
    final aiChatBloc =
        useMemoized(() => sl<AiChatBloc>()..add(const AiChatStarted()));

    // Ensure we close the BLoC when the screen is disposed to avoid memory leaks.
    useEffect(() {
      return () => aiChatBloc.close();
    }, [aiChatBloc]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
        ),
        BlocProvider.value(
          value: aiChatBloc,
        ),
      ],
      child: Builder(
        builder: (context) => Scaffold(
          appBar: _buildAppBar(theme),
          body: _buildBody(theme, context),
          floatingActionButton: _buildFloatingActionButtons(theme, context),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: Icon(Ionicons.chevron_back,
              color: theme.appBarTheme.iconTheme?.color),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleTitleAndDate(theme),
          _buildArticleImage(theme),
          if (article?.isExclusive == true) _buildAiAnalysis(theme),
          _buildArticleDescription(theme),
          const SizedBox(height: 100), // Space for FABs
        ],
      ),
    );
  }

  Widget _buildArticleTitleAndDate(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article?.title ?? '',
            style: theme.textTheme.headlineMedium,
          ),

          const SizedBox(height: 14),
          // DateTime
          Row(
            children: [
              Icon(Ionicons.time_outline,
                  size: 16, color: theme.textTheme.bodyMedium?.color),
              const SizedBox(width: 4),
              Text(
                '${article?.publishedAt ?? ''} · ${ReadingTimeHelper.calculateReadingTime(article?.content)} min read',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage(ThemeData theme) {
    return Container(
      width: double.maxFinite,
      height: 250,
      margin: const EdgeInsets.only(top: 14),
      child: Image.network(
        article?.urlToImage ?? '',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: Center(
            child: Icon(Icons.image_not_supported_outlined,
                size: 40, color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleDescription(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Text(
        '${article?.description ?? ''}\n\n${article?.content ?? ''}',
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildAiAnalysis(ThemeData theme) {
    final isNewspaper =
        theme.scaffoldBackgroundColor == AppColors.newspaperScaffold;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNewspaper
            ? Colors.transparent
            : (isDark
                ? Colors.white.withOpacity(0.05)
                : AppColors.accent.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(isNewspaper ? 0 : 20),
        border: isNewspaper
            ? Border.all(color: theme.dividerColor, width: 1)
            : Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'AI ANALYSIS (SYMMETRY INSIGHTS)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article?.description ?? 'No summary available.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: isNewspaper ? FontStyle.italic : null,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(ThemeData theme, BuildContext context) {
    final isNewspaper =
        theme.scaffoldBackgroundColor == AppColors.newspaperScaffold;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Ask AI Button (The "Wink")
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isNewspaper ? 12 : 30),
            gradient: isNewspaper ? null : AppColors.fabGradient,
            color: isNewspaper ? const Color.fromARGB(227, 255, 0, 0) : null,
            boxShadow: isNewspaper
                ? null
                : [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
            border: isNewspaper
                ? Border.all(color: AppColors.newspaperTextPrimary, width: 1)
                : null,
          ),
          child: FloatingActionButton.extended(
            heroTag: 'ask_ai',
            onPressed: () => _showAskAiSheet(context, theme),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            label: const Text('Ask AI ',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        // Original Bookmark FAB - Reactive & Robust
        BlocBuilder<LocalArticleBloc, LocalArticlesState>(
          builder: (context, state) {
            final isLoading = state is LocalArticlesLoading;
            bool isSaved = false;

            if (state is LocalArticlesDone) {
              isSaved =
                  state.articles?.any((a) => a.url == article?.url) ?? false;
            }

            return FloatingActionButton(
              mini: true,
              heroTag: 'bookmark',
              onPressed: isLoading
                  ? null
                  : () => _onFloatingActionButtonPressed(context, isSaved),
              backgroundColor: isLoading
                  ? Colors.grey
                  : (isNewspaper
                      ? AppColors.newspaperScaffold
                      : AppColors.darkSurface),
              shape: isNewspaper ? const RoundedRectangleBorder() : null,
              child: isLoading
                  ? const CupertinoActivityIndicator(
                      radius: 8, color: Colors.white)
                  : Icon(
                      isSaved ? Ionicons.bookmark : Ionicons.bookmark_outline,
                      color: isNewspaper
                          ? AppColors.newspaperTextPrimary
                          : Colors.white,
                      size: 20,
                    ),
            );
          },
        ),
      ],
    );
  }

  void _showAskAiSheet(BuildContext context, ThemeData theme) {
    final articleContext =
        '${article?.title ?? ''} ${article?.description ?? ''} ${article?.content ?? ''}';

    final aiBloc = context.read<AiChatBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: aiBloc,
        child: _AiChatSheet(theme: theme, articleContext: articleContext),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(BuildContext context, bool isSaved) {
    final theme = Theme.of(context);
    final isNewspaper =
        theme.scaffoldBackgroundColor == AppColors.newspaperScaffold;

    if (isSaved) {
      if (article != null) {
        BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article!));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.bookmark_remove_rounded,
                  color: isNewspaper
                      ? AppColors.newspaperTextPrimary
                      : Colors.white,
                  size: 18),
              const SizedBox(width: 8),
              Text(
                'Article removed from favorites.',
                style: TextStyle(
                  color: isNewspaper
                      ? AppColors.newspaperTextPrimary
                      : Colors.white,
                  fontFamily: isNewspaper ? 'Serif' : null,
                ),
              ),
            ],
          ),
          backgroundColor:
              isNewspaper ? AppColors.newspaperScaffold : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isNewspaper ? 0 : 12)),
        ),
      );
      return;
    }

    if (article != null) {
      BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.bookmark_added,
                color:
                    isNewspaper ? AppColors.newspaperTextPrimary : Colors.white,
                size: 18),
            const SizedBox(width: 8),
            Text(
              'Article saved successfully.',
              style: TextStyle(
                color:
                    isNewspaper ? AppColors.newspaperTextPrimary : Colors.white,
                fontFamily: isNewspaper ? 'Serif' : null,
                fontWeight: isNewspaper ? FontWeight.bold : null,
              ),
            ),
          ],
        ),
        backgroundColor:
            isNewspaper ? AppColors.newspaperScaffold : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isNewspaper ? 0 : 12)),
      ),
    );
  }
}

// ─── Reactive Chat Sheet ──────────────────────────────────────────────────────
// Separate HookWidget so we can correctly use useScrollController
// and useTextEditingController inside the bottom sheet builder.
class _AiChatSheet extends HookWidget {
  final ThemeData theme;
  final String articleContext;

  const _AiChatSheet({required this.theme, required this.articleContext});

  @override
  Widget build(BuildContext context) {
    final isNewspaper =
        theme.scaffoldBackgroundColor == AppColors.newspaperScaffold;
    final isDark = theme.brightness == Brightness.dark;

    final scrollController = useScrollController();
    final textController = useTextEditingController();

    void scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    void sendMessage(AiChatBloc bloc) {
      final text = textController.text.trim();
      if (text.isEmpty) return;
      textController.clear();
      bloc.add(AiChatSendMessage(
        userMessage: text,
        articleContext: articleContext,
      ));
    }

    return BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: isDark ? 10 : 0, sigmaY: isDark ? 10 : 0),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            color: isNewspaper
                ? AppColors.newspaperScaffold
                : (isDark
                    ? AppColors.darkSurface.withOpacity(0.95)
                    : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isNewspaper ? 0 : 30),
              topRight: Radius.circular(isNewspaper ? 0 : 30),
            ),
            border: Border.all(
              color: isNewspaper
                  ? theme.dividerColor
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // ── Handle ──
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // ── Header ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 22, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Text(
                      isNewspaper
                          ? 'ASK THE CORRESPONDENT'
                          : 'Symmetry Oracle ✨',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontFamily: isNewspaper ? 'Serif' : null,
                        color: isNewspaper
                            ? AppColors.newspaperTextPrimary
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: theme.dividerColor, height: 1),
              // ── Chat History ──
              Expanded(
                child: BlocConsumer<AiChatBloc, AiChatState>(
                  listener: (context, state) {
                    if (state is AiChatHistoryUpdated || state is AiChatError) {
                      scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    final messages = _getMessages(state);
                    final isLoading = state is AiChatLoading;

                    if (messages.isEmpty && !isLoading) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            isNewspaper
                                ? 'Ask your question and the correspondent will answer based solely on this report.'
                                : 'Ask anything about this article.\nThe Oracle will only answer from the text above.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontFamily: isNewspaper ? 'Serif' : null,
                              fontStyle: isNewspaper ? FontStyle.italic : null,
                              color: isNewspaper
                                  ? AppColors.newspaperTextPrimary
                                      .withOpacity(0.6)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: messages.length + (isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (isLoading && index == messages.length) {
                          return _buildTypingIndicator(
                              isNewspaper, isDark, theme);
                        }
                        return _buildMessageBubble(
                          messages[index],
                          isNewspaper,
                          isDark,
                          theme,
                        );
                      },
                    );
                  },
                ),
              ),
              // ── Input Field ──
              _buildInputBar(context, textController, sendMessage, isNewspaper,
                  isDark, theme),
            ],
          ),
        ),
      ),
    );
  }

  List _getMessages(AiChatState state) {
    if (state is AiChatHistoryUpdated) return state.messages;
    if (state is AiChatLoading) return state.messages;
    if (state is AiChatError) return state.messages;
    return [];
  }

  Widget _buildMessageBubble(
    dynamic message,
    bool isNewspaper,
    bool isDark,
    ThemeData theme,
  ) {
    final isUser = message.isFromUser as bool;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser
              ? (isNewspaper ? AppColors.newspaperAccent : AppColors.accent)
              : (isNewspaper
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.grey.shade100)),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: (!isUser && isNewspaper)
              ? Border.all(color: theme.dividerColor)
              : null,
        ),
        child: Text(
          message.text as String,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUser
                ? Colors.white
                : (isNewspaper
                    ? Colors.black87
                    : (isDark ? Colors.white : Colors.black87)),
            fontFamily: isNewspaper ? 'Serif' : null,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isNewspaper, bool isDark, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isNewspaper
              ? Colors.transparent
              : (isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.grey.shade100),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          border: isNewspaper ? Border.all(color: theme.dividerColor) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 14, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              isNewspaper
                  ? 'Consulting the archive...'
                  : 'Oracle is thinking...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontStyle: FontStyle.italic,
                fontFamily: isNewspaper ? 'Serif' : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    TextEditingController textController,
    void Function(AiChatBloc) sendMessage,
    bool isNewspaper,
    bool isDark,
    ThemeData theme,
  ) {
    return BlocBuilder<AiChatBloc, AiChatState>(
      builder: (context, state) {
        final isLoading = state is AiChatLoading;
        final bloc = context.read<AiChatBloc>();

        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  enabled: !isLoading,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(
                    fontFamily: isNewspaper ? 'Serif' : null,
                    color: isNewspaper
                        ? Colors.black87
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                  decoration: InputDecoration(
                    hintText: isNewspaper
                        ? 'Your question to the correspondent...'
                        : 'Ask the Oracle...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: isNewspaper ? 'Serif' : null,
                    ),
                    filled: true,
                    fillColor: isNewspaper
                        ? Colors.white
                        : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isNewspaper ? 4 : 24),
                      borderSide: isNewspaper
                          ? BorderSide(color: theme.dividerColor)
                          : BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(isNewspaper ? 4 : 24),
                      borderSide: isNewspaper
                          ? BorderSide(color: theme.dividerColor)
                          : BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: isLoading ? null : () => sendMessage(bloc),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isNewspaper ? null : AppColors.fabGradient,
                    color: isNewspaper ? AppColors.newspaperAccent : null,
                    borderRadius: BorderRadius.circular(isNewspaper ? 4 : 22),
                    boxShadow: isNewspaper
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Icon(
                    isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
