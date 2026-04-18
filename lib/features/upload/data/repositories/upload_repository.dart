import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/config/app_config.dart';
import '../../../photo/data/models/photo_model.dart';
import '../../../../core/network/dio_client.dart';

class ImgBBException implements Exception {
  final String message;
  ImgBBException(this.message);
}

class UploadRepository {
  Future<PhotoModel> uploadImage({
    required String filePath,
    required String filename,
    required void Function(double progress) onProgress,
  }) async {
    final bytes = await File(filePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    final formData = FormData.fromMap({
      'key': AppConfig.imgbbApiKey,
      'image': base64Image,
      'name': filename,
    });

    try {
      final response = await DioClient.instance.post(
        AppConfig.imgbbUploadEndpoint,
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress(sent / total);
        },
      );

      if (response.data['success'] == true) {
        return PhotoModel.fromImgBBResponse(response.data);
      } else {
        throw ImgBBException(response.data['error']['message']);
      }
    } catch (e) {
      if (e is DioException) {
        throw ImgBBException(e.message ?? 'Unknown network error');
      }
      throw ImgBBException(e.toString());
    }
  }
}
