import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyEdgeDetection {
  img.Image execute(img.Image src) {
    if (src.width <= 1 || src.height <= 1) {
      throw img.ImageException(
          'Invalid size: width and height must be greater than 1.');
    }

    img.Image gray = img.grayscale(src); // Convertir l'image en nuances de gris
    img.Image edges =
        img.Image(gray.width, gray.height); // Image pour stocker les bords

    for (int y = 1; y < gray.height - 1; y++) {
      for (int x = 1; x < gray.width - 1; x++) {
        int leftPixel = gray.getPixel(x - 1, y);
        int rightPixel = gray.getPixel(x + 1, y);
        int topPixel = gray.getPixel(x, y - 1);
        int bottomPixel = gray.getPixel(x, y + 1);

        int horizontalDiff =
            (img.getRed(leftPixel) - img.getRed(rightPixel)).abs();
        int verticalDiff =
            (img.getRed(topPixel) - img.getRed(bottomPixel)).abs();

        // Simple threshold
        if (horizontalDiff + verticalDiff > 30) {
          edges.setPixel(x, y, 0xff000000); // Edge
        } else {
          edges.setPixel(x, y, 0xffffffff); // Non-edge
        }
      }
    }

    return edges;
  }
}
