import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'registration_config_state.dart';

class RegistrationConfigCubit extends Cubit<RegistrationConfigState> {
  final Dio _dio;

  RegistrationConfigCubit(this._dio) : super(const RegistrationConfigInitial());

  Future<void> fetch() async {
    try {
      final response = await _dio.get('open-config/');
      final data = response.data;
      final isOpen = data is Map<String, dynamic> && data['is_open'] == true;
      emit(RegistrationConfigLoaded(isOpen: isOpen));
    } catch (_) {
      // On error, hide the register link
      emit(const RegistrationConfigLoaded(isOpen: false));
    }
  }
}
