import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../image_processing/presentation/providers/image_processor_provider.dart';
import '../../../image_processing/presentation/pages/image_editing_page.dart';

class SavedImagesGrid extends StatelessWidget {
  final bool isModified;

  SavedImagesGrid({required this.isModified});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageProcessorProvider>(
      builder: (context, imageProcessor, child) {
        final images = isModified
            ? imageProcessor.modifiedImages
            : imageProcessor.unmodifiedImages;
        return images.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isModified
                    ? 'Aucune image modifiée.'
                    : 'Aucune image non modifiée.'),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imagePath = images[index];
                  return GestureDetector(
                    onTap: () {
                      imageProcessor.loadImageForEditing(imagePath);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageEditingPage()),
                      );
                    },
                    child: Stack(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await imageProcessor.deleteImage(
                                  imagePath, isModified);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Image supprimée')),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}
