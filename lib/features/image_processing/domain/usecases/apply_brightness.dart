import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyBrightness {
  img.Image execute(img.Image image, int brightness) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);

        int r = clamp(img.getRed(pixel) + brightness, 0, 255);
        int g = clamp(img.getGreen(pixel) + brightness, 0, 255);
        int b = clamp(img.getBlue(pixel) + brightness, 0, 255);

        image.setPixel(x, y, img.getColor(r, g, b));
      }
    }
    return image;
  }

  int clamp(int value, int min, int max) {
    return value < min ? min : (value > max ? max : value);
  }
}
