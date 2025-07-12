enum SwapRequestStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}

class SwapRequest {
  final int? id;
  final int fromUserId;
  final int toUserId;
  final String offeredSkills;
  final String requestedSkills;
  final SwapRequestStatus status;
  final DateTime? createdAt;

  SwapRequest({
    this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.offeredSkills,
    required this.requestedSkills,
    this.status = SwapRequestStatus.pending,
    this.createdAt,
  });

  factory SwapRequest.fromJson(Map<String, dynamic> json) {
    return SwapRequest(
      id: json['id'],
      fromUserId: json['From_user_id'] ?? json['from_user_id'],
      toUserId: json['To_user_id'] ?? json['to_user_id'],
      offeredSkills: json['Offered_skiils'] ?? json['offered_skills'],
      requestedSkills: json['Requested_skills'] ?? json['requested_skills'],
      status: _parseStatus(json['Status'] ?? json['status']),
      createdAt: json['Created_at'] != null 
          ? DateTime.parse(json['Created_at']) 
          : null,
    );
  }

  static SwapRequestStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return SwapRequestStatus.accepted;
      case 'rejected':
        return SwapRequestStatus.rejected;
      case 'cancelled':
        return SwapRequestStatus.cancelled;
      default:
        return SwapRequestStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'From_user_id': fromUserId,
      'To_user_id': toUserId,
      'Offered_skiils': offeredSkills,
      'Requested_skills': requestedSkills,
      'Status': status.name,
      'Created_at': createdAt?.toIso8601String(),
    };
  }

  SwapRequest copyWith({
    int? id,
    int? fromUserId,
    int? toUserId,
    String? offeredSkills,
    String? requestedSkills,
    SwapRequestStatus? status,
    DateTime? createdAt,
  }) {
    return SwapRequest(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      offeredSkills: offeredSkills ?? this.offeredSkills,
      requestedSkills: requestedSkills ?? this.requestedSkills,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 