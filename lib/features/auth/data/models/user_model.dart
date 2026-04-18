import 'dart:convert';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarPath,
    required super.storageUsed,
    required super.storagePlan,
    required super.storageLimit,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarPath: json['avatarPath'],
      storageUsed: json['storageUsed'] ?? 0,
      storagePlan: json['storagePlan'] ?? 'free',
      storageLimit: json['storageLimit'] ?? 5368709120,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarPath': avatarPath,
      'storageUsed': storageUsed,
      'storagePlan': storagePlan,
      'storageLimit': storageLimit,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJsonString(String source) => UserModel.fromJson(json.decode(source));
  String toJsonString() => json.encode(toJson());
}
