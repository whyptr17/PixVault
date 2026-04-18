abstract class PhotoEvent {}

class LoadPhotos extends PhotoEvent {}

class ToggleFavorite extends PhotoEvent {
  final String id;
  ToggleFavorite(this.id);
}

class DeletePhoto extends PhotoEvent {
  final String id;
  DeletePhoto(this.id);
}
