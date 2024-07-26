import 'package:flutter/material.dart';

class ResizeDialog extends StatefulWidget {
  final Function(int, int) onResize;

  ResizeDialog({required this.onResize});

  @override
  _ResizeDialogState createState() => _ResizeDialogState();
}

class _ResizeDialogState extends State<ResizeDialog> {
  final _largeurController = TextEditingController();
  final _hauteurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Redimensionner l\'image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _largeurController,
            decoration: InputDecoration(labelText: 'Largeur'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _hauteurController,
            decoration: InputDecoration(labelText: 'Hauteur'),
            keyboardType: TextInputType.number,
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
            final largeur = int.tryParse(_largeurController.text);
            final hauteur = int.tryParse(_hauteurController.text);
            if (largeur != null && hauteur != null) {
              widget.onResize(largeur, hauteur);
              Navigator.of(context).pop();
            }
          },
          child: Text('Redimensionner'),
        ),
      ],
    );
  }
}
