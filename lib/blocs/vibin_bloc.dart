import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/vibin_events.dart';
import '../vibin_states.dart';


class NumberBloc extends Bloc<NumberEvent, NumberState> {
  NumberBloc() : super(NumberState(queue: [5, 4, 3, 2, 1])) {
    on<StartEmitting>(_startEmitting);
  }

  Future<void> _startEmitting(StartEmitting event, Emitter<NumberState> emit) async {
    final randomNumber = Random().nextInt(100);
    var updatedQueue = List<int>.from(state.queue);
    updatedQueue.add(randomNumber); // Add new random number to the queue

    // Check if there is at least one number to emit
    if (updatedQueue.isNotEmpty) {
      await Future.delayed(Duration(seconds: Random().nextInt(2) + 3));

      // Check again in case the bloc was closed during the delay
      if (isClosed) {
        return;
      }
      final emittedNumber = updatedQueue.removeAt(0); // Simulate emission by removing the first item
      emit(NumberState(queue: updatedQueue, lastEmitted: emittedNumber));
      if (!isClosed) {
        await _startEmitting(event, emit); // Reschedule the next emission
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}