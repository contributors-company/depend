import 'package:bloc/bloc.dart';

import '../services.dart';

part 'default_event.dart';
part 'default_state.dart';

class DefaultBloc extends Bloc<DefaultEvent, DefaultState> {
  final AuthRepository _authRepository;

  DefaultBloc(this._authRepository) : super(DefaultState()) {
    on<DefaultEvent>((event, emit) {
      _authRepository.login();
      emit(DefaultState(authorized: true));
    });
  }
}
