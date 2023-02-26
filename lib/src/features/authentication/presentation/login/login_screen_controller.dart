import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../application/authentication_service.dart';
part 'login_screen_controller.g.dart';

@riverpod
class LoginScreenController extends _$LoginScreenController {
  Future<void> didTapLogin() async {
    final authenticationService = ref.read(authenticationServiceProvider);
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() async => await authenticationService.login());
  }

  @override
  FutureOr<void> build() {}
}
