import 'package:flutter/material.dart';
import 'dart:io';

class FullImagePage extends StatelessWidget {
  final String imagePath;

  FullImagePage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Plein Écran'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
