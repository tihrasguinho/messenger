// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

class FriendSchema extends Friend {
  FriendSchema({
    required super.uid,
    required super.userUid,
    required super.friendUid,
    required super.createdAt,
  });

  factory FriendSchema.empty() {
    return FriendSchema(
      uid: '',
      userUid: '',
      friendUid: '',
      createdAt: DateTime.now(),
    );
  }

  factory FriendSchema.create({
    required String userUid,
    required String friendUid,
  }) {
    return FriendSchema(
      uid: '', // WILL BE AUTOMATICALLY GENERATED
      userUid: userUid,
      friendUid: friendUid,
      createdAt: DateTime.now(), // WILL BE AUTOMATICALLY GENERATED
    );
  }

  static FriendSchema fromMap(Map<String, dynamic> map) {
    return FriendSchema(
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

  FriendSchema copyWith({
    String? userUid,
    String? friendUid,
  }) {
    return FriendSchema(
      uid: uid,
      userUid: userUid ?? this.userUid,
      friendUid: friendUid ?? this.friendUid,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> save() => SQLeto.instance.update<FriendSchema>(() => this);

  @override
  Future<void> delete() => SQLeto.instance.delete<FriendSchema>(() => this);

  @override
  String get tableName => 'tb_friend';
}
