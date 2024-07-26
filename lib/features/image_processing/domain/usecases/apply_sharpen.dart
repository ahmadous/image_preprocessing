import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplySharpen {
  img.Image execute(img.Image image) {
    // Filtre de renforcement (sharpen)
    final kernel = [
      [0, -1, 0],
      [-1, 5, -1],
      [0, -1, 0]
    ];

    final result = img.Image(image.width, image.height);

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        int r = 0, g = 0, b = 0;

        for (int ky = 0; ky < 3; ky++) {
          for (int kx = 0; kx < 3; kx++) {
            int pixel = image.getPixel(x + kx - 1, y + ky - 1);
            r += img.getRed(pixel) * kernel[ky][kx];
            g += img.getGreen(pixel) * kernel[ky][kx];
            b += img.getBlue(pixel) * kernel[ky][kx];
          }
        }

        result.setPixel(x, y,
            img.getColor(r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255)));
      }
    }

    return result;
  }
}
