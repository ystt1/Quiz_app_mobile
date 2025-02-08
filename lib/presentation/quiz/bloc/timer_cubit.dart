import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/presentation/quiz/bloc/timer_state.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  Timer? _timer;

  WorkoutCubit() : super(const WorkoutInitial());

  void onTick(Timer timer) {
    if (state is WorkoutInProgress) {
      final wip = state as WorkoutInProgress;

      if (wip.elapsed! > 0) {
        emit(WorkoutInProgress(wip.elapsed! - 1));
      } else {
        _timer?.cancel();
        WakelockPlus.disable();
        emit(const WorkoutFinish());
        _onTimeUp();
      }
    }
  }

  void startWorkout(int totalTime) {
    WakelockPlus.enable();
    emit(WorkoutInProgress(totalTime));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void _onTimeUp() {
    submitAnswers("pending");
  }

  void submitAnswers(String status) {

  }

  @override
  Future<void> close() {
    _timer?.cancel();
    WakelockPlus.disable();
    return super.close();
  }
}
