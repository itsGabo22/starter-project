import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<String> _tags = [];
  String? _aiSummary;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title);
    _contentController = TextEditingController(text: widget.article?.content);
    _tags = widget.article?.aiEnhancements?.tags ?? [];
    _aiSummary = widget.article?.aiEnhancements?.aiSummary;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
              const SnackBar(content: Text('✨ AI Metadata Generated!'), backgroundColor: Colors.deepPurple),
            );
          }
          if (state is JournalistEditorSuccess) {
            Navigator.pop(context); // Go back to dashboard on success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Article Saved Successfully!'), backgroundColor: Colors.green),
            );
          }
          if (state is JournalistEditorError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}'), backgroundColor: Colors.red),
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
    return AppBar(
      title: Text(
        widget.article == null ? 'New Article' : 'Edit Article',
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.close, color: Colors.black),
      ),
      actions: [
        BlocBuilder<JournalistEditorCubit, JournalistEditorState>(
          builder: (context, state) {
            return IconButton(
              onPressed: state is JournalistEditorGeneratingAI ? null : () => _onSavePressed(context),
              icon: state is JournalistEditorSaving 
                ? const CupertinoActivityIndicator() 
                : const Icon(Icons.check, color: Colors.deepPurple),
            );
          },
        )
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEditorFields(),
          const SizedBox(height: 30),
          _buildAiEnhancementsSection(),
        ],
      ),
    );
  }

  Widget _buildEditorFields() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: 'Headline',
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
        const Divider(),
        TextField(
          controller: _contentController,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Write your story...',
            border: InputBorder.none,
          ),
          maxLines: null,
        ),
      ],
    );
  }

  Widget _buildAiEnhancementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('AI ENHANCEMENTS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
            BlocBuilder<JournalistEditorCubit, JournalistEditorState>(
              builder: (context, state) {
                return TextButton.icon(
                  onPressed: state is JournalistEditorGeneratingAI ? null : () => _onGenerateAiMetadata(context),
                  icon: state is JournalistEditorGeneratingAI 
                    ? const SizedBox(width: 15, height: 15, child: CupertinoActivityIndicator(radius: 8)) 
                    : const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Enhance ✨'),
                  style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_aiSummary != null)...[
            const Text('Summary', style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(_aiSummary!, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
            const SizedBox(height: 10),
        ],
        Wrap(
          spacing: 8,
          children: _tags.map((tag) => Chip(
            label: Text('#$tag', style: const TextStyle(color: Colors.deepPurple, fontSize: 12)),
            backgroundColor: Colors.deepPurple.withOpacity(0.05),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
             const Icon(Icons.image_outlined, color: Colors.grey),
             const SizedBox(width: 15),
             const Icon(Icons.text_fields, color: Colors.grey),
             const Spacer(),
             const Text('Draft', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _onGenerateAiMetadata(BuildContext context) {
    if (_contentController.text.isNotEmpty) {
      context.read<JournalistEditorCubit>().generateAiMetadata(_contentController.text);
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please write some content first!')),
            );
    }
  }

  void _onSavePressed(BuildContext context) {
    final article = JournalistArticleEntity(
      id: widget.article?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      aiEnhancements: JournalistAiEnhancementsEntity(
        aiSummary: _aiSummary,
        tags: _tags,
      ),
      metadata: JournalistMetadataEntity(
        status: 'draft',
        createdAt: widget.article?.metadata?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    context.read<JournalistEditorCubit>().saveArticle(article);
  }
}
