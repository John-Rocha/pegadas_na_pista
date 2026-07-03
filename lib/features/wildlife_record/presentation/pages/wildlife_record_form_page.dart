import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/environmental_data.dart';
import '../../domain/entities/roadkill_details.dart';
import '../../domain/entities/sighting_details.dart';
import '../../domain/entities/wildlife_record_type.dart';
import '../cubit/wildlife_record_cubit.dart';
import '../cubit/wildlife_record_state.dart';
import '../widgets/environmental_data_form.dart';
import '../widgets/location_section.dart';
import '../widgets/photo_picker_section.dart';
import '../widgets/record_type_selector.dart';
import '../widgets/roadkill_details_form.dart';
import '../widgets/sighting_details_form.dart';
import '../widgets/species_selector.dart';
import '../widgets/wildlife_record_review_section.dart';

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
            if (state is WildlifeRecordFormEditing &&
                state.validationError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.validationError!)),
              );
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
              WildlifeRecordInitial() => RecordTypeSelector(
                onSelected: cubit.initializeForm,
              ),
              WildlifeRecordLoadingLocation() ||
              WildlifeRecordSubmitting() ||
              WildlifeRecordUploadingPhotos() => const Center(
                child: CircularProgressIndicator(),
              ),
              WildlifeRecordFormEditing(
                draft: final draft,
                isReviewing: true,
              ) =>
                WildlifeRecordReviewSection(
                  draft: draft,
                  onEdit: cubit.backToEdit,
                  onSubmit: cubit.submit,
                ),
              WildlifeRecordFormEditing(
                draft: final draft,
                especies: final especies,
              ) =>
                SingleChildScrollView(
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
                      const SizedBox(height: 16),
                      LocationSection(
                        latitude: draft.latitude,
                        longitude: draft.longitude,
                        precisaoLocalizacaoM: draft.precisaoLocalizacaoM,
                        onRetry: cubit.retryLocation,
                      ),
                      const Divider(height: 32),
                      SpeciesSelector(
                        especies: especies,
                        especieId: draft.especieId,
                        nomeEspecieInformado: draft.nomeEspecieInformado,
                        onEspecieIdChanged: (value) => cubit.updateDraft(
                          (d) => d.copyWith(especieId: value),
                        ),
                        onNomeInformadoChanged: (value) => cubit.updateDraft(
                          (d) => d.copyWith(nomeEspecieInformado: value),
                        ),
                      ),
                      const Divider(height: 32),
                      EnvironmentalDataForm(
                        data:
                            draft.dadosAmbientais ?? const EnvironmentalData(),
                        onChanged: (value) => cubit.updateDraft(
                          (d) => d.copyWith(dadosAmbientais: value),
                        ),
                      ),
                      const Divider(height: 32),
                      if (draft.type == WildlifeRecordType.roadkill)
                        RoadkillDetailsForm(
                          details:
                              draft.dadosAtropelamento ??
                              const RoadkillDetails(),
                          rodovia: draft.rodovia,
                          kmRodovia: draft.kmRodovia,
                          municipio: draft.municipio,
                          onDetailsChanged: (value) => cubit.updateDraft(
                            (d) => d.copyWith(dadosAtropelamento: value),
                          ),
                          onRodoviaChanged: (value) => cubit.updateDraft(
                            (d) => d.copyWith(rodovia: value),
                          ),
                          onKmRodoviaChanged: (value) => cubit.updateDraft(
                            (d) => d.copyWith(kmRodovia: value),
                          ),
                          onMunicipioChanged: (value) => cubit.updateDraft(
                            (d) => d.copyWith(municipio: value),
                          ),
                        )
                      else
                        SightingDetailsForm(
                          details:
                              draft.dadosAvistamento ?? const SightingDetails(),
                          onChanged: (value) => cubit.updateDraft(
                            (d) => d.copyWith(dadosAvistamento: value),
                          ),
                        ),
                      const Divider(height: 32),
                      PhotoPickerSection(
                        fotos: draft.fotos,
                        photoRequired:
                            draft.type == WildlifeRecordType.roadkill,
                        onAdd: (source) => cubit.addPhoto(source: source),
                        onRemove: cubit.removePhoto,
                      ),
                      const Divider(height: 32),
                      TextFormField(
                        initialValue: draft.observacoes,
                        decoration: const InputDecoration(
                          labelText: 'Observações',
                        ),
                        maxLines: 3,
                        onChanged: (value) => cubit.updateDraft(
                          (d) => d.copyWith(observacoes: value),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: cubit.validateAndReview,
                        child: const Text('Revisar'),
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
