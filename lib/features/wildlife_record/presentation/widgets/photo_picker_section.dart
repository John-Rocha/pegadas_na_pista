import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/record_photo.dart';

class PhotoPickerSection extends StatelessWidget {
  const PhotoPickerSection({
    super.key,
    required this.fotos,
    required this.photoRequired,
    required this.onAdd,
    required this.onRemove,
  });

  final List<RecordPhoto> fotos;
  final bool photoRequired;
  final ValueChanged<ImageSource> onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          photoRequired ? 'Fotos (obrigatória)' : 'Fotos (recomendada)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (fotos.isNotEmpty)
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: fotos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final photo = fotos[index];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: photo.localPath != null
                          ? Image.file(
                              File(photo.localPath!),
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 96,
                              height: 96,
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => onRemove(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => onAdd(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Câmera'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => onAdd(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Galeria'),
            ),
          ],
        ),
      ],
    );
  }
}
