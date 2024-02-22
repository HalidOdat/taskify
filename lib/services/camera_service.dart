import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  late final ImagePicker _picker;
  static final CameraService _instance = CameraService._internal();
  CameraService._internal() {
    _picker = ImagePicker();
  }
  factory CameraService() {
    return _instance;
  }

  Future<File?> takeAndSaveImage() async {
    final XFile? photo =
        await CameraService()._picker.pickImage(source: ImageSource.camera);

    if (photo == null) {
      return null;
    }

    final applicationDir = await getApplicationDocumentsDirectory();

    final file = File(photo.path);
    final input = await file.readAsBytes();

    final output =
        File(path.join(applicationDir.path, path.basename(photo.path)));
    await output.writeAsBytes(input);
    return output;
  }
}
