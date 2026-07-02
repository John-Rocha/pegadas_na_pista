import 'package:flutter/material.dart';

import '../../domain/entities/trail.dart';

class TrailListTile extends StatelessWidget {
  const TrailListTile({required this.trail, required this.onDelete, super.key});

  final Trail trail;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.route),
      title: Text(trail.name),
      subtitle: Text('${trail.points.length} points • ${trail.createdAt}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
