import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplySobelEdgeDetection {
  img.Image execute(img.Image image) {
    final width = image.width;
    final height = image.height;

    final sobelX = [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1],
    ];

    final sobelY = [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1],
    ];

    final result = img.Image(width, height);

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        int pixelX = (sobelX[0][0] * img.getRed(image.getPixel(x - 1, y - 1)) +
                sobelX[0][1] * img.getRed(image.getPixel(x, y - 1)) +
                sobelX[0][2] * img.getRed(image.getPixel(x + 1, y - 1)) +
                sobelX[1][0] * img.getRed(image.getPixel(x - 1, y)) +
                sobelX[1][1] * img.getRed(image.getPixel(x, y)) +
                sobelX[1][2] * img.getRed(image.getPixel(x + 1, y)) +
                sobelX[2][0] * img.getRed(image.getPixel(x - 1, y + 1)) +
                sobelX[2][1] * img.getRed(image.getPixel(x, y + 1)) +
                sobelX[2][2] * img.getRed(image.getPixel(x + 1, y + 1)))
            .abs();

        int pixelY = (sobelY[0][0] * img.getRed(image.getPixel(x - 1, y - 1)) +
                sobelY[0][1] * img.getRed(image.getPixel(x, y - 1)) +
                sobelY[0][2] * img.getRed(image.getPixel(x + 1, y - 1)) +
                sobelY[1][0] * img.getRed(image.getPixel(x - 1, y)) +
                sobelY[1][1] * img.getRed(image.getPixel(x, y)) +
                sobelY[1][2] * img.getRed(image.getPixel(x + 1, y)) +
                sobelY[2][0] * img.getRed(image.getPixel(x - 1, y + 1)) +
                sobelY[2][1] * img.getRed(image.getPixel(x, y + 1)) +
                sobelY[2][2] * img.getRed(image.getPixel(x + 1, y + 1)))
            .abs();

        int val = (pixelX + pixelY).clamp(0, 255);
        result.setPixel(x, y, img.getColor(val, val, val));
      }
    }

    return result;
  }
}
