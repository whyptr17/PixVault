class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarPath;
  final int storageUsed;
  final String storagePlan;
  final int storageLimit;
  final String createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarPath,
    required this.storageUsed,
    required this.storagePlan,
    required this.storageLimit,
    required this.createdAt,
  });
}
