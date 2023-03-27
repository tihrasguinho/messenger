// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

class FriendRequestSchema extends FriendRequest {
  FriendRequestSchema({
    required super.uid,
    required super.userUid,
    required super.friendUid,
    required super.createdAt,
  });

  factory FriendRequestSchema.empty() {
    return FriendRequestSchema(
      uid: '',
      userUid: '',
      friendUid: '',
      createdAt: DateTime.now(),
    );
  }

  factory FriendRequestSchema.create({
    required String userUid,
    required String friendUid,
  }) {
    return FriendRequestSchema(
      uid: '', // WILL BE AUTOMATICALLY GENERATED
      userUid: userUid,
      friendUid: friendUid,
      createdAt: DateTime.now(), // WILL BE AUTOMATICALLY GENERATED
    );
  }

  static FriendRequestSchema fromMap(Map<String, dynamic> map) {
    return FriendRequestSchema(
      uid: map['uid'] ?? '',
      userUid: map['user_uid'] ?? '',
      friendUid: map['friend_uid'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'user_uid': userUid,
        'friend_uid': friendUid,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  FriendRequestSchema copyWith({
    String? userUid,
    String? friendUid,
  }) {
    return FriendRequestSchema(
      uid: uid,
      userUid: userUid ?? this.userUid,
      friendUid: friendUid ?? this.friendUid,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> save() =>
      SQLeto.instance.update<FriendRequestSchema>(() => this);

  @override
  Future<void> delete() =>
      SQLeto.instance.delete<FriendRequestSchema>(() => this);

  @override
  String get tableName => 'tb_friend_request';
}
