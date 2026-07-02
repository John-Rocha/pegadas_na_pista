import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../errors/failures.dart';
import '../result.dart';

class MediaService {
  MediaService({required this.picker});

  final ImagePicker picker;

  Future<Result<String>> captureTrailPhoto() async {
    try {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1600,
      );
      if (image == null) {
        return const Error(UnexpectedFailure('Photo capture cancelled.'));
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}${p.extension(image.path)}';
      final savedPath = p.join(directory.path, 'trail_photos', fileName);
      await Directory(p.dirname(savedPath)).create(recursive: true);
      await File(image.path).copy(savedPath);
      return Success(savedPath);
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
