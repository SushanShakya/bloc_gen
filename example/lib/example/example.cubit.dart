import 'package:warped_bloc/warped_bloc.dart';
import './example.interface.dart';

class LoginSuccess extends DataState {
  const LoginSuccess({required super.data});
}

class LoginCubit extends AsyncCubit {
  final ILoginRepo repo;
  LoginCubit({
    required this.repo,
  });

  login() {
    handleDefaultStates(() async {
      final data = await repo.login();
      emit(LoginSuccess(data: data));
    });
  }
}
