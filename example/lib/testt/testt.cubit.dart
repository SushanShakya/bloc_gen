import 'package:warped_bloc/warped_bloc.dart';
import './testt.interface.dart';

class XLoaded extends DataState {
  const XLoaded({required super.data});
}

class XCubit extends AsyncCubit {
  final IXRepo repo;
  XCubit({
    required this.repo,
  });

  x() {
    handleDefaultStates(() async {
      final data = await repo.x();
      emit(XLoaded(data: data));
    });
  }
}
