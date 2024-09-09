import 'package:flutter/material.dart';

class ResizeDialog extends StatefulWidget {
  final Function(int, int) onResize;

  ResizeDialog({required this.onResize});

  @override
  _ResizeDialogState createState() => _ResizeDialogState();
}

class _ResizeDialogState extends State<ResizeDialog> {
  int _width = 100;
  int _height = 100;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Redimensionner l\'image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Largeur'),
            onChanged: (value) {
              setState(() {
                _width = int.tryParse(value) ?? 100;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Hauteur'),
            onChanged: (value) {
              setState(() {
                _height = int.tryParse(value) ?? 100;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onResize(_width, _height);
            Navigator.of(context).pop();
          },
          child: Text('Redimensionner'),
        ),
      ],
    );
  }
}
