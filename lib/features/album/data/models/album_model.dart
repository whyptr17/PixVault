import 'package:hive/hive.dart';

part 'album_model.g.dart';

@HiveType(typeId: 1)
class AlbumModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) String? coverPhotoId;
  @HiveField(3) List<String> photoIds;
  @HiveField(4) bool isPrivate;
  @HiveField(5) String createdAt;
  @HiveField(6) String updatedAt;

  AlbumModel({
    required this.id,
    required this.name,
    this.coverPhotoId,
    required this.photoIds,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
  });
}
