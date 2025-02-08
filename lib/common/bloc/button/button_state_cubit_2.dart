import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/button/button_state_2.dart';


import '../../../core/usecase.dart';

class ButtonStateCubit2 extends Cubit<ButtonState2> {
  ButtonStateCubit2() : super(ButtonInitialState2());

  Future<void> execute({dynamic params, required UseCase usecase,String? type,int? index}) async {
    emit(ButtonLoadingState2());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold((error) {
        emit(ButtonFailureState2(errorMessage: error));
      }, (data) {
        emit(ButtonSuccessState2(type ?? "default_type", index ?? 0));
      });
    } catch (e) {
      emit(ButtonFailureState2(errorMessage: e.toString()));
    }
  }
}
