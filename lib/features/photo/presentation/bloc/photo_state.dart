import '../data/models/photo_model.dart';

abstract class PhotoState {}

class PhotoInitial extends PhotoState {}
class PhotoLoading extends PhotoState {}
class PhotoLoaded extends PhotoState {
  final List<PhotoModel> photos;
  final Set<String> selectedIds;
  final bool selectionMode;
  
  PhotoLoaded({
    required this.photos,
    this.selectedIds = const {},
    this.selectionMode = false,
  });
}
class PhotoError extends PhotoState {
  final String message;
  PhotoError(this.message);
}
