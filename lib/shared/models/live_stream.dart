/// Modelo de transmisión en vivo
class LiveStream {
  final String id;
  final String creatorId;
  final String creatorName;
  final String creatorAvatar;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final bool isActive;
  final bool isPublic;
  final int pricePerMinute;
  final String? agoraChannelName;
  final String? agoraToken;
  final LiveViewers viewers;
  final Map<String, ActiveViewer> activeViewers;
  final LiveStats stats;
  final LiveSettings settings;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiveStream({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.title,
    this.description = '',
    this.thumbnailUrl,
    this.isActive = false,
    this.isPublic = true,
    this.pricePerMinute = 1,
    this.agoraChannelName,
    this.agoraToken,
    LiveViewers? viewers,
    Map<String, ActiveViewer>? activeViewers,
    LiveStats? stats,
    LiveSettings? settings,
    this.startedAt,
    this.endedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : viewers = viewers ?? LiveViewers(),
       activeViewers = activeViewers ?? {},
       stats = stats ?? LiveStats(),
       settings = settings ?? LiveSettings();

  /// Crea una copia con campos modificados
  LiveStream copyWith({
    String? id,
    String? creatorId,
    String? creatorName,
    String? creatorAvatar,
    String? title,
    String? description,
    String? thumbnailUrl,
    bool? isActive,
    bool? isPublic,
    int? pricePerMinute,
    String? agoraChannelName,
    String? agoraToken,
    LiveViewers? viewers,
    Map<String, ActiveViewer>? activeViewers,
    LiveStats? stats,
    LiveSettings? settings,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LiveStream(
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isActive: isActive ?? this.isActive,
      isPublic: isPublic ?? this.isPublic,
      pricePerMinute: pricePerMinute ?? this.pricePerMinute,
      agoraChannelName: agoraChannelName ?? this.agoraChannelName,
      agoraToken: agoraToken ?? this.agoraToken,
      viewers: viewers ?? this.viewers,
      activeViewers: activeViewers ?? this.activeViewers,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
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
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'isActive': isActive,
      'isPublic': isPublic,
      'pricePerMinute': pricePerMinute,
      'agoraChannelName': agoraChannelName,
      'agoraToken': agoraToken,
      'viewers': viewers.toJson(),
      'activeViewers': activeViewers.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'stats': stats.toJson(),
      'settings': settings.toJson(),
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Crea desde Map de Firestore
  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      creatorName: json['creatorName'] as String,
      creatorAvatar: json['creatorAvatar'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? true,
      pricePerMinute: json['pricePerMinute'] as int? ?? 1,
      agoraChannelName: json['agoraChannelName'] as String?,
      agoraToken: json['agoraToken'] as String?,
      viewers: json['viewers'] != null
          ? LiveViewers.fromJson(json['viewers'] as Map<String, dynamic>)
          : LiveViewers(),
      activeViewers: json['activeViewers'] != null
          ? (json['activeViewers'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                ActiveViewer.fromJson(value as Map<String, dynamic>),
              ),
            )
          : {},
      stats: json['stats'] != null
          ? LiveStats.fromJson(json['stats'] as Map<String, dynamic>)
          : LiveStats(),
      settings: json['settings'] != null
          ? LiveSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : LiveSettings(),
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'LiveStream(id: $id, title: $title, isActive: $isActive)';
  }
}

/// Información de viewers
class LiveViewers {
  final int current;
  final int peak;
  final int total;

  LiveViewers({this.current = 0, this.peak = 0, this.total = 0});

  Map<String, dynamic> toJson() {
    return {'current': current, 'peak': peak, 'total': total};
  }

  factory LiveViewers.fromJson(Map<String, dynamic> json) {
    return LiveViewers(
      current: json['current'] as int? ?? 0,
      peak: json['peak'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

/// Viewer activo
class ActiveViewer {
  final DateTime joinedAt;
  final String username;

  ActiveViewer({required this.joinedAt, required this.username});

  Map<String, dynamic> toJson() {
    return {'joinedAt': joinedAt.toIso8601String(), 'username': username};
  }

  factory ActiveViewer.fromJson(Map<String, dynamic> json) {
    return ActiveViewer(
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      username: json['username'] as String,
    );
  }
}

/// Estadísticas del live
class LiveStats {
  final int totalDuration;
  final int totalLikes;
  final int totalComments;
  final int totalGifts;
  final double totalEarnings;

  LiveStats({
    this.totalDuration = 0,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.totalGifts = 0,
    this.totalEarnings = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalDuration': totalDuration,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'totalGifts': totalGifts,
      'totalEarnings': totalEarnings,
    };
  }

  factory LiveStats.fromJson(Map<String, dynamic> json) {
    return LiveStats(
      totalDuration: json['totalDuration'] as int? ?? 0,
      totalLikes: json['totalLikes'] as int? ?? 0,
      totalComments: json['totalComments'] as int? ?? 0,
      totalGifts: json['totalGifts'] as int? ?? 0,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// Configuración del live
class LiveSettings {
  final bool allowComments;
  final bool allowGifts;
  final bool recordStream;

  LiveSettings({
    this.allowComments = true,
    this.allowGifts = true,
    this.recordStream = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'allowComments': allowComments,
      'allowGifts': allowGifts,
      'recordStream': recordStream,
    };
  }

  factory LiveSettings.fromJson(Map<String, dynamic> json) {
    return LiveSettings(
      allowComments: json['allowComments'] as bool? ?? true,
      allowGifts: json['allowGifts'] as bool? ?? true,
      recordStream: json['recordStream'] as bool? ?? true,
    );
  }
}
