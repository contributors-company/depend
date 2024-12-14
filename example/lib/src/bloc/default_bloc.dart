import 'package:bloc/bloc.dart';

import '../services.dart';

part 'default_event.dart';
part 'default_state.dart';

class DefaultBloc extends Bloc<DefaultEvent, DefaultState> {
  final IAuthRepository _authRepository;

  DefaultBloc(this._authRepository) : super(DefaultState()) {
    on<DefaultEvent>((event, emit) async {
      final result = await _authRepository.login();
      emit(DefaultState(authorized: true, token: result));
    });
  }
}
