import 'package:sqleto/sqleto.dart';

import 'user.dart';

part 'friend.g.dart';

abstract class Friend extends SQLetoSchema {
  @Field(type: SQLetoType.UUID, defaultValue: SQLetoDefaultValue.UUID_GENERATE_V4, primaryKey: true)
  final String uid;

  @Field(type: SQLetoType.UUID, references: User)
  final String userUid;

  @Field(type: SQLetoType.UUID, references: User)
  final String friendUid;

  @Field(type: SQLetoType.TIMESTAMPTZ, defaultValue: SQLetoDefaultValue.NOW)
  final DateTime createdAt;

  Friend({required this.uid, required this.userUid, required this.friendUid, required this.createdAt});
}
