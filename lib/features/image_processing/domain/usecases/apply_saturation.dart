import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';

@injectable
class ApplySaturation {
  img.Image execute(img.Image image, double saturation) {
    return img.adjustColor(image, saturation: saturation);
  }
}
