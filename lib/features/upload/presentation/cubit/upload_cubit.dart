import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_state.dart';
import '../../data/repositories/upload_repository.dart';

class UploadCubit extends Cubit<UploadState> {
  final UploadRepository _uploadRepository = UploadRepository();
  List<UploadItem> _queue = [];

  UploadCubit() : super(UploadInitial());

  void addFiles(List<String> filePaths) {
    for (var path in filePaths) {
      final filename = path.split('/').last;
      _queue.add(UploadItem(localPath: path, filename: filename));
    }
    emit(UploadProgress(_queue));
  }

  Future<void> startUpload() async {
    final pendingItems = _queue.where((item) => item.status == UploadStatus.pending).toList();

    for (var i = 0; i < pendingItems.length; i += 3) {
      final batch = pendingItems.skip(i).take(3);
      await Future.wait(batch.map((item) => _uploadSingle(item)));
    }
  }

  Future<void> _uploadSingle(UploadItem item) async {
    item.status = UploadStatus.uploading;
    emit(UploadProgress(List.from(_queue)));

    try {
      final result = await _uploadRepository.uploadImage(
        filePath: item.localPath,
        filename: item.filename,
        onProgress: (progress) {
          item.progress = progress;
          emit(UploadProgress(List.from(_queue)));
        },
      );

      item.status = UploadStatus.done;
      item.progress = 1.0;
      // TODO: Save result to photoRepository here.
      emit(UploadProgress(List.from(_queue)));
    } catch (e) {
      item.status = UploadStatus.failed;
      item.errorMsg = e.toString();
      emit(UploadProgress(List.from(_queue)));
    }
  }

  void clearCompleted() {
    _queue.removeWhere((item) => item.status == UploadStatus.done);
    emit(UploadProgress(List.from(_queue)));
  }
}
