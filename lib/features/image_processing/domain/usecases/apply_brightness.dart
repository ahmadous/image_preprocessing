import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplyBrightness {
  img.Image execute(img.Image image, int brightness) {
    return img.adjustColor(image, brightness: brightness);
  }
}
