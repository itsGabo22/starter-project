import 'package:equatable/equatable.dart';

class JournalistArticleEntity extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final JournalistAuthorEntity? author;
  final JournalistMediaEntity? media;
  final JournalistMetadataEntity? metadata;
  final JournalistAiEnhancementsEntity? aiEnhancements;
  final JournalistMetricsEntity? metrics;

  const JournalistArticleEntity({
    this.id,
    this.title,
    this.content,
    this.author,
    this.media,
    this.metadata,
    this.aiEnhancements,
    this.metrics,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        author,
        media,
        metadata,
        aiEnhancements,
        metrics,
      ];
}

class JournalistAuthorEntity extends Equatable {
  final String? uid;
  final String? name;
  final String? avatarUrl;

  const JournalistAuthorEntity({
    this.uid,
    this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [uid, name, avatarUrl];
}

class JournalistMediaEntity extends Equatable {
  final String? thumbnailURL;

  const JournalistMediaEntity({
    required this.thumbnailURL,
  });

  @override
  List<Object?> get props => [thumbnailURL];
}

class JournalistMetadataEntity extends Equatable {
  final String? status; // 'draft' | 'published' | 'archived'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  const JournalistMetadataEntity({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  @override
  List<Object?> get props => [status, createdAt, updatedAt, publishedAt];
}

class JournalistAiEnhancementsEntity extends Equatable {
  final String? aiSummary;
  final List<String>? tags;
  final double? estimatedReadTime;

  const JournalistAiEnhancementsEntity({
    this.aiSummary,
    this.tags,
    this.estimatedReadTime,
  });

  @override
  List<Object?> get props => [aiSummary, tags, estimatedReadTime];
}

class JournalistMetricsEntity extends Equatable {
  final int? views;
  final int? likes;

  const JournalistMetricsEntity({
    this.views,
    this.likes,
  });

  @override
  List<Object?> get props => [views, likes];
}
