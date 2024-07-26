import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyHue {
  img.Image execute(img.Image image, double hue) {
    return img.adjustColor(image, hue: hue);
  }
}
