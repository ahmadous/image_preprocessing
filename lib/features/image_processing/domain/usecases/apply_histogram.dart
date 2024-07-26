import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyHistogram {
  img.Image execute(img.Image image) {
    return _equalizeHistogram(image);
  }

  img.Image _equalizeHistogram(img.Image image) {
    const int numberOfWindows = 100;
    List<int> histogram = List.filled(numberOfWindows, 0);
    List<int> cdf = List.filled(numberOfWindows, 0);

    // Step 1: Calculate the histogram
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int brightness =
            (img.getLuminance(image.getPixel(x, y)) * (numberOfWindows / 256))
                .floor();
        histogram[brightness]++;
      }
    }

    // Step 2: Calculate the cumulative distribution function (CDF)
    cdf[0] = histogram[0];
    for (int i = 1; i < numberOfWindows; i++) {
      cdf[i] = cdf[i - 1] + histogram[i];
    }

    // Step 3: Normalize the CDF
    int cdfMin = cdf.firstWhere((value) => value > 0);
    int totalPixels = image.width * image.height;
    List<int> equalized = List.filled(numberOfWindows, 0);
    for (int i = 0; i < numberOfWindows; i++) {
      equalized[i] =
          ((cdf[i] - cdfMin) / (totalPixels - cdfMin) * (numberOfWindows - 1))
              .round();
    }

    // Step 4: Apply the equalized histogram to the image
    img.Image result = img.Image(image.width, image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int brightness =
            (img.getLuminance(pixel) * (numberOfWindows / 256)).floor();
        int newBrightness =
            (equalized[brightness] * (256 / numberOfWindows)).round();
        int alpha = img.getAlpha(pixel);

        result.setPixel(x, y,
            img.getColor(newBrightness, newBrightness, newBrightness, alpha));
      }
    }

    return result;
  }
}
