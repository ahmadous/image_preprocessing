import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../domain/usecases/apply_histogram.dart';
import '../../domain/usecases/apply_contrast.dart';
import '../../domain/usecases/apply_smoothing.dart';
import '../../domain/usecases/apply_edge_detection.dart';
import '../../domain/usecases/apply_rotation.dart';
import '../../domain/usecases/apply_resize.dart';
import '../../domain/usecases/apply_brightness.dart';
import '../../domain/usecases/apply_saturation.dart';
import '../../domain/usecases/apply_hue.dart';
import '../../domain/usecases/apply_sharpen.dart';
import '../../domain/usecases/apply_laplacian_edge_detection.dart';

@injectable
class ImageProcessorProvider extends ChangeNotifier {
  final ApplyHistogram _applyHistogram;
  final ApplyContrast _applyContrast;
  final ApplySmoothing _applySmoothing;
  final ApplyEdgeDetection _applyEdgeDetection;
  final ApplyRotation _applyRotation;
  final ApplyResize _applyResize;
  final ApplyBrightness _applyBrightness;
  final ApplySaturation _applySaturation;
  final ApplyHue _applyHue;
  final ApplySharpen _applySharpen;
  final ApplyLaplacianEdgeDetection _applyLaplacianEdgeDetection;

  img.Image? _originalImage;
  img.Image? _processedImage;
  List<String> _modifiedImages = [];
  List<String> _unmodifiedImages = [];

  ImageProcessorProvider(
    this._applyHistogram,
    this._applyContrast,
    this._applySmoothing,
    this._applyEdgeDetection,
    this._applyRotation,
    this._applyResize,
    this._applyBrightness,
    this._applySaturation,
    this._applyHue,
    this._applySharpen,
    this._applyLaplacianEdgeDetection,
  );

  img.Image? get originalImage => _originalImage;
  img.Image? get processedImage => _processedImage;
  List<String> get modifiedImages => _modifiedImages;
  List<String> get unmodifiedImages => _unmodifiedImages;

  void setImage(img.Image image) {
    _originalImage = image;
    _processedImage =
        img.copyResize(image, width: image.width, height: image.height);
    notifyListeners();
  }

  Future<void> loadImageForEditing(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        _originalImage = image;
        _processedImage =
            img.copyResize(image, width: image.width, height: image.height);
        notifyListeners();
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image != null) {
        setImage(image);
      }
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
    ].request();
  }

  String applyHistogram() {
    if (_processedImage != null) {
      _processedImage = _applyHistogram.execute(_processedImage!);
      notifyListeners();
      return 'Histogramme appliqué';
    }
    return 'Aucune image à traiter';
  }

  String applyContrast(double contrast) {
    if (_processedImage != null) {
      _processedImage = _applyContrast.execute(_processedImage!, contrast);
      notifyListeners();
      return 'Contraste ajusté';
    }
    return 'Aucune image à traiter';
  }

  String applySmoothing() {
    if (_processedImage != null) {
      _processedImage = _applySmoothing.execute(_processedImage!);
      notifyListeners();
      return 'Lissage appliqué';
    }
    return 'Aucune image à traiter';
  }

  String applyEdgeDetection() {
    if (_processedImage != null) {
      _processedImage = _applyEdgeDetection.execute(_processedImage!);
      notifyListeners();
      return 'Détection de contours appliquée';
    }
    return 'Aucune image à traiter';
  }

  String applyRotation(int angle) {
    if (_processedImage != null) {
      _processedImage = _applyRotation.execute(_processedImage!, angle);
      notifyListeners();
      return 'Image tournée';
    }
    return 'Aucune image à traiter';
  }

  String applyResize(int width, int height) {
    if (_processedImage != null) {
      _processedImage = _applyResize.execute(_processedImage!, width, height);
      notifyListeners();
      return 'Image redimensionnée';
    }
    return 'Aucune image à traiter';
  }

  String applyBrightness(int brightness) {
    if (_processedImage != null) {
      _processedImage = _applyBrightness.execute(_processedImage!, brightness);
      notifyListeners();
      return 'Luminosité ajustée';
    }
    return 'Aucune image à traiter';
  }

  String applySaturation(double saturation) {
    if (_processedImage != null) {
      _processedImage = _applySaturation.execute(_processedImage!, saturation);
      notifyListeners();
      return 'Saturation ajustée';
    }
    return 'Aucune image à traiter';
  }

  String applyHue(double hue) {
    if (_processedImage != null) {
      _processedImage = _applyHue.execute(_processedImage!, hue);
      notifyListeners();
      return 'Teinte ajustée';
    }
    return 'Aucune image à traiter';
  }

  String applySharpen() {
    if (_processedImage != null) {
      _processedImage = _applySharpen.execute(_processedImage!);
      notifyListeners();
      return 'Filtre de renforcement appliqué';
    }
    return 'Aucune image à traiter';
  }

  String applyLaplacianEdgeDetection() {
    if (_processedImage != null) {
      _processedImage = _applyLaplacianEdgeDetection.execute(_processedImage!);
      notifyListeners();
      return 'Détection de contours Laplacian appliquée';
    }
    return 'Aucune image à traiter';
  }

  void resetImage() {
    _processedImage = img.copyResize(_originalImage!,
        width: _originalImage!.width, height: _originalImage!.height);
    notifyListeners();
  }

  Future<String> saveImage(bool isModified) async {
    if (_processedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      file.writeAsBytesSync(img.encodePng(_processedImage!));

      final prefs = await SharedPreferences.getInstance();
      if (isModified) {
        _modifiedImages = prefs.getStringList('modified_images') ?? [];
        _modifiedImages.add(file.path);
        await prefs.setStringList('modified_images', _modifiedImages);
      } else {
        _unmodifiedImages = prefs.getStringList('unmodified_images') ?? [];
        _unmodifiedImages.add(file.path);
        await prefs.setStringList('unmodified_images', _unmodifiedImages);
      }

      notifyListeners();
      return 'Image enregistrée';
    }
    return 'Aucune image à enregistrer';
  }

  Future<void> loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    _modifiedImages = prefs.getStringList('modified_images') ?? [];
    _unmodifiedImages = prefs.getStringList('unmodified_images') ?? [];
    notifyListeners();
  }

  Future<void> deleteImage(String path, bool isModified) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    final prefs = await SharedPreferences.getInstance();
    if (isModified) {
      _modifiedImages.remove(path);
      await prefs.setStringList('modified_images', _modifiedImages);
    } else {
      _unmodifiedImages.remove(path);
      await prefs.setStringList('unmodified_images', _unmodifiedImages);
    }

    notifyListeners();
  }
}
