import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/wildlife_record_type.dart';
import '../cubit/wildlife_record_cubit.dart';
import '../cubit/wildlife_record_state.dart';

class WildlifeRecordFormPage extends StatelessWidget {
  const WildlifeRecordFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WildlifeRecordCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Registrar ocorrência')),
        body: BlocConsumer<WildlifeRecordCubit, WildlifeRecordState>(
          listener: (context, state) {
            if (state is WildlifeRecordError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is WildlifeRecordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Registro enviado com sucesso. '
                    'Seu registro ficará pendente até validação técnica.',
                  ),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final cubit = context.read<WildlifeRecordCubit>();
            return switch (state) {
              WildlifeRecordInitial() => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          cubit.initializeForm(WildlifeRecordType.roadkill),
                      child: const Text('Atropelamento'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          cubit.initializeForm(WildlifeRecordType.sighting),
                      child: const Text('Avistamento'),
                    ),
                  ],
                ),
              ),
              WildlifeRecordLoadingLocation() ||
              WildlifeRecordSubmitting() ||
              WildlifeRecordUploadingPhotos() => const Center(
                child: CircularProgressIndicator(),
              ),
              WildlifeRecordFormEditing(draft: final draft) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      draft.type == WildlifeRecordType.roadkill
                          ? 'Atropelamento'
                          : 'Avistamento',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Latitude: ${draft.latitude}'),
                    Text('Longitude: ${draft.longitude}'),
                    Text('Data: ${draft.dataOcorrencia.toLocal()}'),
                    Text('Hora: ${draft.horaOcorrencia}'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: cubit.submit,
                      child: const Text('Enviar'),
                    ),
                  ],
                ),
              ),
              WildlifeRecordSuccess() ||
              WildlifeRecordError() => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
