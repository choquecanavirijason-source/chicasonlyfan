/// Tipo de publicación
enum PostType {
  photo,
  video;

  String toJson() => name;

  static PostType fromJson(String json) {
    return PostType.values.firstWhere(
      (type) => type.name == json,
      orElse: () => PostType.photo,
    );
  }
}

/// Modelo de publicación (foto o video)
class Post {
  final String id;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final PostType type;
  final String mediaUrl;
  final String? thumbnailUrl;
  final String title;
  final String description;
  final int price;
  final bool isFree;
  final int? duration;
  final String? resolution;
  final PostStats stats;
  final List<String> tags;
  final List<String> viewedBy;
  final List<String> likedBy;
  final bool isActive;
  final bool isReported;
  final int reportCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.type,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.title,
    this.description = '',
    this.price = 0,
    this.isFree = false,
    this.duration,
    this.resolution,
    PostStats? stats,
    this.tags = const [],
    this.viewedBy = const [],
    this.likedBy = const [],
    this.isActive = true,
    this.isReported = false,
    this.reportCount = 0,
    required this.createdAt,
    required this.updatedAt,
  }) : stats = stats ?? PostStats();

  /// Crea una copia con campos modificados
  Post copyWith({
    String? id,
    String? creatorId,
    String? creatorName,
    String? creatorAvatar,
    PostType? type,
    String? mediaUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    int? price,
    bool? isFree,
    int? duration,
    String? resolution,
    PostStats? stats,
    List<String>? tags,
    List<String>? viewedBy,
    List<String>? likedBy,
    bool? isActive,
    bool? isReported,
    int? reportCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      duration: duration ?? this.duration,
      resolution: resolution ?? this.resolution,
      stats: stats ?? this.stats,
      tags: tags ?? this.tags,
      viewedBy: viewedBy ?? this.viewedBy,
      likedBy: likedBy ?? this.likedBy,
      isActive: isActive ?? this.isActive,
      isReported: isReported ?? this.isReported,
      reportCount: reportCount ?? this.reportCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'creatorAvatar': creatorAvatar,
      'type': type.toJson(),
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
      'duration': duration,
      'resolution': resolution,
      'stats': stats.toJson(),
      'tags': tags,
      'viewedBy': viewedBy,
      'likedBy': likedBy,
      'isActive': isActive,
      'isReported': isReported,
      'reportCount': reportCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      creatorAvatar: json['creatorAvatar'] as String,
      type: PostType.fromJson(json['type'] as String),
      mediaUrl: json['mediaUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      price: json['price'] as int? ?? 0,
      isFree: json['isFree'] as bool? ?? false,
      duration: json['duration'] as int?,
      resolution: json['resolution'] as String?,
      stats: json['stats'] != null
          ? PostStats.fromJson(json['stats'] as Map<String, dynamic>)
          : PostStats(),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      viewedBy:
          (json['viewedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      likedBy:
          (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      isReported: json['isReported'] as bool? ?? false,
      reportCount: json['reportCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, type: $type)';
  }
}

/// Estadísticas del post
class PostStats {
  final int views;
  final int likes;
  final int comments;
  final int shares;
  final double earnings;

  PostStats({
    this.views = 0,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.earnings = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'views': views,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'earnings': earnings,
    };
  }

  factory PostStats.fromJson(Map<String, dynamic> json) {
    return PostStats(
      views: json['views'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      shares: json['shares'] as int? ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
