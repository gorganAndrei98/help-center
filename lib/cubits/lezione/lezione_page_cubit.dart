import 'package:flu/locator/locator.dart';
import 'package:flu/server_requests/core/http_requests_core.dart';
import 'package:flu/server_requests/core/lezione_requests.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LezioneCubit extends Cubit<CubitState> {
  final LezioneRequests requests;

  LezioneCubit({required this.requests}) : super(InitialCubitState());

  void increaseCounter({int? extraCounter}) {
    if (extraCounter != null)
      return emit(state.copyWith(counter: state.counter + extraCounter));
    emit(state.copyWith(counter: state.counter + 1));
  }

  Future<void> initRandomCounter() async {
    emit(state.copyWith(status: LezionePageStatus.loading));
    final randomInt = await requests.getRandomInt();
    emit(CubitState(counter: randomInt));
  }
}

enum LezionePageStatus { loading, success, failure }

class CubitState {
  final int counter;
  final LezionePageStatus status;

  CubitState({required this.counter, this.status = LezionePageStatus.success});

  CubitState copyWith({
    int? counter,
    LezionePageStatus? status,
  }) {
    return CubitState(
      counter: counter ?? this.counter,
      status: status ?? this.status,
    );
  }
}

class InitialCubitState extends CubitState {
  InitialCubitState() : super(counter: 0);
}
