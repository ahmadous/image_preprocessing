import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyResize {
  img.Image execute(img.Image image, int width, int height) {
    if (width <= 0 || height <= 0) {
      throw img.ImageException(
          'Invalid size: width and height must be greater than 0.');
    }
    return img.copyResize(image, width: width, height: height);
  }
}
