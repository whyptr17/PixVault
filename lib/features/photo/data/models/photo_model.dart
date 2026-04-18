import 'package:hive/hive.dart';

part 'photo_model.g.dart';

@HiveType(typeId: 0)
class PhotoModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) String filename;
  @HiveField(3) int size;
  @HiveField(4) int width;
  @HiveField(5) int height;
  @HiveField(6) String url;
  @HiveField(7) String displayUrl;
  @HiveField(8) String thumbUrl;
  @HiveField(9) String deleteUrl;
  @HiveField(10) String viewerUrl;
  @HiveField(11) String htmlEmbed;
  @HiveField(12) String bbCode;
  @HiveField(13) List<String> tags;
  @HiveField(14) String? albumId;
  @HiveField(15) bool isFavorite;
  @HiveField(16) bool isPrivate;
  @HiveField(17) String uploadedAt;

  PhotoModel({
    required this.id,
    required this.title,
    required this.filename,
    required this.size,
    required this.width,
    required this.height,
    required this.url,
    required this.displayUrl,
    required this.thumbUrl,
    required this.deleteUrl,
    required this.viewerUrl,
    required this.htmlEmbed,
    required this.bbCode,
    required this.tags,
    this.albumId,
    required this.isFavorite,
    required this.isPrivate,
    required this.uploadedAt,
  });

  factory PhotoModel.fromImgBBResponse(Map<String, dynamic> json) {
    final data = json['data'];
    return PhotoModel(
      id: data['id'],
      title: data['title'] ?? data['image']['filename'],
      filename: data['image']['filename'],
      size: int.parse(data['size'].toString()),
      width: int.parse(data['image']['width'].toString()),
      height: int.parse(data['image']['height'].toString()),
      url: data['url'],
      displayUrl: data['display_url'],
      thumbUrl: data['thumb']['url'],
      deleteUrl: data['delete_url'],
      viewerUrl: data['url_viewer'],
      htmlEmbed: '',
      bbCode: '[img]${data['url']}[/img]',
      tags: [],
      albumId: null,
      isFavorite: false,
      isPrivate: false,
      uploadedAt: DateTime.now().toIso8601String(),
    );
  }
}
