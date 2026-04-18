import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'photo_event.dart';
import 'photo_state.dart';
import '../../data/models/photo_model.dart';
import '../../../../core/storage/hive_boxes.dart';

abstract class PhotoEvent {}
class LoadPhotos extends PhotoEvent {}
class ToggleFavorite extends PhotoEvent { final String id; ToggleFavorite(this.id); }
class DeletePhoto extends PhotoEvent { final String id; DeletePhoto(this.id); }

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final Box<PhotoModel> _photoBox = Hive.box<PhotoModel>(HiveBoxes.photos);

  PhotoBloc() : super(PhotoInitial()) {
    on<LoadPhotos>((event, emit) {
      emit(PhotoLoading());
      final photos = _photoBox.values.toList();
      photos.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      emit(PhotoLoaded(photos: photos));
    });

    on<ToggleFavorite>((event, emit) async {
      final state = this.state;
      if (state is PhotoLoaded) {
        final photo = _photoBox.get(event.id);
        if (photo != null) {
          photo.isFavorite = !photo.isFavorite;
          await photo.save();
          add(LoadPhotos());
        }
      }
    });

    on<DeletePhoto>((event, emit) async {
      await _photoBox.delete(event.id);
      add(LoadPhotos());
    });
  }
}
