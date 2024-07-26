import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyLaplacianEdgeDetection {
  img.Image execute(img.Image src) {
    img.Image gray = img.grayscale(src); // Convertir l'image en nuances de gris
    img.Image edges =
        img.Image(gray.width, gray.height); // Image pour stocker les bords

    for (int y = 1; y < gray.height - 1; y++) {
      for (int x = 1; x < gray.width - 1; x++) {
        int pixel = gray.getPixel(x, y);
        int leftPixel = gray.getPixel(x - 1, y);
        int rightPixel = gray.getPixel(x + 1, y);
        int topPixel = gray.getPixel(x, y - 1);
        int bottomPixel = gray.getPixel(x, y + 1);

        int laplacian = (img.getRed(leftPixel) +
                img.getRed(rightPixel) +
                img.getRed(topPixel) +
                img.getRed(bottomPixel) -
                4 * img.getRed(pixel))
            .abs();

        int val = laplacian.clamp(0, 255);
        edges.setPixel(x, y, img.getColor(val, val, val));
      }
    }

    return edges;
  }
}
