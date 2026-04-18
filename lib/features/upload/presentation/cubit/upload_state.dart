abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadProgress extends UploadState {
  final List<UploadItem> queue;
  UploadProgress(this.queue);
}

class UploadItem {
  final String localPath;
  final String filename;
  double progress;
  UploadStatus status;
  String? errorMsg;

  UploadItem({
    required this.localPath,
    required this.filename,
    this.progress = 0.0,
    this.status = UploadStatus.pending,
    this.errorMsg,
  });
}

enum UploadStatus { pending, uploading, done, failed }
