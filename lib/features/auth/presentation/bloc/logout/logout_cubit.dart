import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yuksalish_mobile/core/error/exceptions.dart';
import 'package:yuksalish_mobile/core/services/my_shared_preferences.dart';
import '../../../domain/usecases/logout_user.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUser _logoutUser;

  LogoutCubit(this._logoutUser) : super(const LogoutInitial());

  Future<void> logout() async {
    if (state is LogoutLoading) {
      return;
    }

    final refreshToken = MySharedPreferences.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      // No token but user wants to logout - just clear any remaining data
      await MySharedPreferences.clearUserData();
      emit(const LogoutSuccess('Logged out successfully.'));
      return;
    }

    emit(const LogoutLoading());
    try {
      final result = await _logoutUser(
        LogoutUserParams(refreshToken: refreshToken),
      );

      // Always clear local data regardless of API result
      // The API call is to invalidate server sessions - local logout should always succeed
      await MySharedPreferences.clearUserData();

      result.fold(
        (failure) => emit(const LogoutSuccess('Logged out locally.')),
        (response) => emit(LogoutSuccess(response.message)),
      );
    } on NetworkException catch (_) {
      // Network error - still clear local data and logout
      await MySharedPreferences.clearUserData();
      emit(const LogoutSuccess('Logged out locally.'));
    } on ServerExceptions catch (_) {
      // Server error - still clear local data and logout
      await MySharedPreferences.clearUserData();
      emit(const LogoutSuccess('Logged out locally.'));
    } catch (_) {
      // Any other error - still clear local data and logout
      await MySharedPreferences.clearUserData();
      emit(const LogoutSuccess('Logged out locally.'));
    }
  }
}
