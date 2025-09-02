import 'dart:async';
import '../../authentification/domain/usecases/refresh_token_usecase.dart';
import '../app/injection_container.dart' as di;
import '../storage/secure_storage.dart';

class TokenRefreshService {
  Timer? _refreshTimer;

  void startTokenRefresh() async {
    final tokenRefreshInterval = await SecureStorage.getExpiresIn();
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      Duration(seconds: tokenRefreshInterval ?? 3600),
      (timer) async {
        await _refreshToken();
      },
    );
  }

  void stopTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> _refreshToken() async {
     final token = SecureStorage.getToken();

    final refreshUseCase = di.sl<RefreshTokenUseCase>();
    final result = await refreshUseCase.call();

    result.fold(
      (failure) {
        // Handle token refresh failure
        stopTokenRefresh();
      },
      (newToken) async {
        // await prefs.setString(AppConstants.tokenKey, newToken);
      },
    );
    }

  void dispose() {
    stopTokenRefresh();
  }
}
