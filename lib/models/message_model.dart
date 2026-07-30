/// Model pesan chat — erd.md FIXv2.2: sender_id dihapus,
/// diganti customer_sender_id + driver_sender_id.
///
/// Format API response belum terdokumentasi di §7.
/// fromJson toleran terhadap kedua kemungkinan.
class MessageModel {
  final String id;
  final String orderId;
  final String senderType;
  final String? customerSenderId;
  final String? driverSenderId;
  final String? content;
  final String messageType;
  final MessageAttachment? attachment;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.orderId,
    required this.senderType,
    this.customerSenderId,
    this.driverSenderId,
    this.content,
    required this.messageType,
    this.attachment,
    required this.createdAt,
  });

  /// ID pengirim — getter turunan dari dua kolom FK + senderType.
  /// TODO(sprint-8): Konfirmasi format actual dari services/chat Go code.
  String? get senderId =>
      senderType == 'customer' ? customerSenderId : driverSenderId;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      senderType: json['sender_type'] as String,
      customerSenderId: (json['customer_sender_id'] ??
              (json['sender_type'] == 'customer' ? json['sender_id'] : null))
          as String?,
      driverSenderId: (json['driver_sender_id'] ??
              (json['sender_type'] == 'driver' ? json['sender_id'] : null))
          as String?,
      content: json['content'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
      attachment: json['attachment'] != null
          ? MessageAttachment.fromJson(
              json['attachment'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class MessageAttachment {
  final String id;
  final String? presignedUrl;
  final DateTime? presignedUrlExpiresAt;
  final String? thumbUrl;
  final DateTime? thumbExpiresAt;
  final String scanStatus;
  final String? originalFilename;
  final int? fileSizeBytes;
  final String? mimeType;

  const MessageAttachment({
    required this.id,
    this.presignedUrl,
    this.presignedUrlExpiresAt,
    this.thumbUrl,
    this.thumbExpiresAt,
    required this.scanStatus,
    this.originalFilename,
    this.fileSizeBytes,
    this.mimeType,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      presignedUrl: json['presigned_url'] as String?,
      presignedUrlExpiresAt: json['presigned_url_expires_at'] != null
          ? DateTime.parse(json['presigned_url_expires_at'] as String).toUtc()
          : null,
      thumbUrl: json['thumb_url'] as String?,
      thumbExpiresAt: json['thumb_expires_at'] != null
          ? DateTime.parse(json['thumb_expires_at'] as String).toUtc()
          : null,
      scanStatus: json['scan_status'] as String? ?? 'pending',
      originalFilename: json['original_filename'] as String?,
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
    );
  }

  /// Apakah URL akan expired dalam < 1 jam?
  /// technical-strategies.md §3 (Client-Triggered Batch Refresh).
  bool get needsRefresh {
    if (presignedUrlExpiresAt == null) return false;
    return DateTime.now()
        .toUtc()
        .add(const Duration(hours: 1))
        .isAfter(presignedUrlExpiresAt!);
  }
}
