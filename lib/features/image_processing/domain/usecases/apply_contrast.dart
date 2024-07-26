import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyContrast {
  img.Image execute(img.Image image, double contrast) {
    if (image.width <= 0 || image.height <= 0) {
      throw img.ImageException(
          'Invalid size: width and height must be greater than 0.');
    }
    return img.adjustColor(image, contrast: contrast);
  }
}
