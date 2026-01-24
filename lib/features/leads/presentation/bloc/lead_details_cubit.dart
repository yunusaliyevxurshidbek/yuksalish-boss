import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/repositories/leads_repository.dart';
import 'lead_details_state.dart';

class LeadDetailsCubit extends Cubit<LeadDetailsState> {
  final LeadsRepository _repository;

  LeadDetailsCubit({required LeadsRepository repository})
      : _repository = repository,
        super(LeadDetailsState.initial());

  Future<void> loadLead(int id) async {
    emit(state.copyWith(status: LeadDetailsStatus.loading));

    try {
      final lead = await _repository.getLeadById(id);
      emit(state.copyWith(
        status: LeadDetailsStatus.loaded,
        lead: lead,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        status: LeadDetailsStatus.error,
        errorMessage: e.message,
      ));
    } on ServerExceptions catch (e) {
      emit(state.copyWith(
        status: LeadDetailsStatus.error,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeadDetailsStatus.error,
        errorMessage: 'Xatolik yuz berdi. Iltimos, qayta urinib ko\'ring.',
      ));
    }
  }

  Future<void> refresh(int id) async {
    await loadLead(id);
  }
}
