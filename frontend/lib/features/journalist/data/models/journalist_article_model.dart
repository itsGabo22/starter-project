import '../../domain/entities/journalist_article.dart';

class JournalistArticleModel extends JournalistArticleEntity {
  const JournalistArticleModel({
    String? id,
    String? title,
    String? content,
    JournalistAuthorModel? author,
    JournalistMediaModel? media,
    JournalistMetadataModel? metadata,
    JournalistAiEnhancementsModel? aiEnhancements,
    JournalistMetricsModel? metrics,
  }) : super(
          id: id,
          title: title,
          content: content,
          author: author,
          media: media,
          metadata: metadata,
          aiEnhancements: aiEnhancements,
          metrics: metrics,
        );

  factory JournalistArticleModel.fromJson(Map<String, dynamic> json) {
    return JournalistArticleModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      author: json['author'] != null ? JournalistAuthorModel.fromJson(json['author']) : null,
      media: json['media'] != null ? JournalistMediaModel.fromJson(json['media']) : null,
      metadata: json['metadata'] != null ? JournalistMetadataModel.fromJson(json['metadata']) : null,
      aiEnhancements: json['ai_enhancements'] != null ? JournalistAiEnhancementsModel.fromJson(json['ai_enhancements']) : null,
      metrics: json['metrics'] != null ? JournalistMetricsModel.fromJson(json['metrics']) : null,
    );
  }

  factory JournalistArticleModel.fromEntity(JournalistArticleEntity entity) {
    return JournalistArticleModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      author: entity.author != null ? JournalistAuthorModel.fromEntity(entity.author!) : null,
      media: entity.media != null ? JournalistMediaModel.fromEntity(entity.media!) : null,
      metadata: entity.metadata != null ? JournalistMetadataModel.fromEntity(entity.metadata!) : null,
      aiEnhancements: entity.aiEnhancements != null ? JournalistAiEnhancementsModel.fromEntity(entity.aiEnhancements!) : null,
      metrics: entity.metrics != null ? JournalistMetricsModel.fromEntity(entity.metrics!) : null,
    );
  }
}

class JournalistAuthorModel extends JournalistAuthorEntity {
  const JournalistAuthorModel({String? uid, String? name, String? avatarUrl}) : super(uid: uid, name: name, avatarUrl: avatarUrl);

  factory JournalistAuthorModel.fromJson(Map<String, dynamic> json) => JournalistAuthorModel(uid: json['uid'], name: json['name'], avatarUrl: json['avatarUrl']);
  factory JournalistAuthorModel.fromEntity(JournalistAuthorEntity entity) => JournalistAuthorModel(uid: entity.uid, name: entity.name, avatarUrl: entity.avatarUrl);
}

class JournalistMediaModel extends JournalistMediaEntity {
  const JournalistMediaModel({required String? thumbnailURL}) : super(thumbnailURL: thumbnailURL);

  factory JournalistMediaModel.fromJson(Map<String, dynamic> json) => JournalistMediaModel(thumbnailURL: json['thumbnailURL']);
  factory JournalistMediaModel.fromEntity(JournalistMediaEntity entity) => JournalistMediaModel(thumbnailURL: entity.thumbnailURL);
}

class JournalistMetadataModel extends JournalistMetadataEntity {
  const JournalistMetadataModel({String? status, DateTime? createdAt, DateTime? updatedAt, DateTime? publishedAt})
      : super(status: status, createdAt: createdAt, updatedAt: updatedAt, publishedAt: publishedAt);

  factory JournalistMetadataModel.fromJson(Map<String, dynamic> json) => JournalistMetadataModel(
        status: json['status'],
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
      );

  factory JournalistMetadataModel.fromEntity(JournalistMetadataEntity entity) => JournalistMetadataModel(
        status: entity.status,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        publishedAt: entity.publishedAt,
      );
}

class JournalistAiEnhancementsModel extends JournalistAiEnhancementsEntity {
  const JournalistAiEnhancementsModel({String? aiSummary, List<String>? tags, double? estimatedReadTime})
      : super(aiSummary: aiSummary, tags: tags, estimatedReadTime: estimatedReadTime);

  factory JournalistAiEnhancementsModel.fromJson(Map<String, dynamic> json) => JournalistAiEnhancementsModel(
        aiSummary: json['aiSummary'],
        tags: (json['tags'] as List?)?.map((e) => e as String).toList(),
        estimatedReadTime: (json['estimatedReadTime'] as num?)?.toDouble(),
      );

  factory JournalistAiEnhancementsModel.fromEntity(JournalistAiEnhancementsEntity entity) => JournalistAiEnhancementsModel(
        aiSummary: entity.aiSummary,
        tags: entity.tags,
        estimatedReadTime: entity.estimatedReadTime,
      );
}

class JournalistMetricsModel extends JournalistMetricsEntity {
  const JournalistMetricsModel({int? views, int? likes}) : super(views: views, likes: likes);

  factory JournalistMetricsModel.fromJson(Map<String, dynamic> json) => JournalistMetricsModel(views: json['views'], likes: json['likes']);
  factory JournalistMetricsModel.fromEntity(JournalistMetricsEntity entity) => JournalistMetricsModel(views: entity.views, likes: entity.likes);
}
