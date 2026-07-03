import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/trail_bloc.dart';
import '../bloc/trail_event.dart';
import '../bloc/trail_state.dart';
import '../widgets/trail_list_tile.dart';

class TrailListPage extends StatelessWidget {
  const TrailListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrailBloc>()..add(const LoadTrails()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pegadas na Pista')),
        body: BlocBuilder<TrailBloc, TrailState>(
          builder: (context, state) {
            return switch (state) {
              TrailInitial() || TrailLoadInProgress() => const Center(
                child: CircularProgressIndicator(),
              ),
              TrailLoadSuccess(trails: final trails) when trails.isEmpty =>
                const Center(child: Text('No trails recorded yet.')),
              TrailLoadSuccess(trails: final trails) => ListView.builder(
                itemCount: trails.length,
                itemBuilder: (context, index) => TrailListTile(
                  trail: trails[index],
                  onDelete: () => context.read<TrailBloc>().add(
                    DeleteTrailRequested(trailId: trails[index].id!),
                  ),
                ),
              ),
              TrailLoadFailure(message: final message) => Center(
                child: Text(message),
              ),
            };
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              heroTag: 'record-wildlife',
              onPressed: () => context.push('/registrar-ocorrencia'),
              icon: const Icon(Icons.pets),
              label: const Text('Registrar ocorrência'),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'record-trail',
              onPressed: () => context.push('/trails/record'),
              child: const Icon(Icons.add_location_alt),
            ),
          ],
        ),
      ),
    );
  }
}
