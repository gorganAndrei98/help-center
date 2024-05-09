import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagesRow extends StatefulWidget {
  final Function(File) onImageSelected;
  final int maxImages;
  final List<String> initialImagePaths;

  const ImagesRow({
    Key? key,
    required this.onImageSelected,
    required this.maxImages,
    required this.initialImagePaths,
  }) : super(key: key);

  @override
  _ImagesRowState createState() => _ImagesRowState();
}

class _ImagesRowState extends State<ImagesRow> {
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    images = widget.initialImagePaths.map((path) => File(path)).toList();
  }

  Future<void> pickImage() async {
    if (images.length >= widget.maxImages) {
      return; // Optionally notify the user
    }
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && image.path.endsWith('.png')) {
      File imgFile = File(image.path);
      setState(() {
        images.add(imgFile);
        widget.onImageSelected(imgFile);
      });
    } else if (image != null && !image.path.endsWith('.png')) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Formatto non supportato"),
            content: const Text("Seleziona un file con formatto PNG."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == images.length && images.length < widget.maxImages) {
            return IconButton(
              icon: Icon(Icons.add),
              onPressed: pickImage,
            );
          } else if (index < images.length) {
            return GestureDetector(
              onTap: () => widget.onImageSelected(images[index]),
              child: Image.file(images[index], fit: BoxFit.cover),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
