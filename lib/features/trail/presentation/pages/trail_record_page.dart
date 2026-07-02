import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../cubit/trail_recording_cubit.dart';
import '../cubit/trail_recording_state.dart';

class TrailRecordPage extends StatefulWidget {
  const TrailRecordPage({super.key});

  @override
  State<TrailRecordPage> createState() => _TrailRecordPageState();
}

class _TrailRecordPageState extends State<TrailRecordPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _trailName => _nameController.text.trim().isEmpty
      ? 'Trail'
      : _nameController.text.trim();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrailRecordingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Record Trail')),
        body: BlocConsumer<TrailRecordingCubit, TrailRecordingState>(
          listener: (context, state) {
            if (state is TrailRecordingError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<TrailRecordingCubit>();
            return switch (state) {
              TrailRecordingIdle() || TrailRecordingError() => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Trail name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cubit.startRecording(_trailName),
                      child: const Text('Start recording'),
                    ),
                  ],
                ),
              ),
              TrailRecordingInProgress(trail: final trail) => Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: trail.points.length,
                      itemBuilder: (context, index) {
                        final point = trail.points[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text('${point.latitude}, ${point.longitude}'),
                          subtitle: point.photoPath != null
                              ? const Text('Photo attached')
                              : null,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => cubit.capturePoint(),
                          icon: const Icon(Icons.add_location),
                          label: const Text('Mark point'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => cubit.capturePoint(withPhoto: true),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Mark + photo'),
                        ),
                        OutlinedButton(
                          onPressed: cubit.finishRecording,
                          child: const Text('Finish'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            };
          },
        ),
      ),
    );
  }
}
