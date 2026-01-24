import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import '../../../domain/usecases/set_password.dart';
import 'set_password_state.dart';

class SetPasswordCubit extends Cubit<SetPasswordState> {
  final SetPassword _setPassword;

  SetPasswordCubit(this._setPassword) : super(const SetPasswordInitial());

  Future<void> submit({
    required String phone,
    required String password,
  }) async {
    emit(const SetPasswordLoading());
    try {
      final result = await _setPassword(
        SetPasswordParams(
          phone: phone,
          password: password,
        ),
      );
      result.fold(
        (failure) => emit(SetPasswordError(failure.message)),
        (response) async {
          await MySharedPreferences.setId(response.user.id);
          await MySharedPreferences.setPhone(response.user.phone);
          final accessToken = response.accessToken.trim();
          if (accessToken.isNotEmpty) {
            await MySharedPreferences.setToken(accessToken);
          }
          final refreshToken = response.refreshToken.trim();
          if (refreshToken.isNotEmpty) {
            await MySharedPreferences.setRefreshToken(refreshToken);
          }
          emit(
            SetPasswordSuccess(
              message: response.message,
              user: response.user,
            ),
          );
        },
      );
    } on NetworkException catch (e) {
      emit(SetPasswordError(e.message));
    } on ServerExceptions catch (e) {
      emit(SetPasswordError(e.message));
    } catch (_) {
      emit(const SetPasswordError('Unexpected error occurred.'));
    }
  }
}
