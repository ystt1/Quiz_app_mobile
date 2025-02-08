abstract class ButtonState{}

class ButtonInitialState extends ButtonState{}

class ButtonLoadingState extends ButtonState{}

class ButtonSuccessState extends ButtonState{
  final String? type;
  final int? index;
  ButtonSuccessState(this.type,this.index);
}

class ButtonFailureState extends ButtonState{
  final String errorMessage;

  ButtonFailureState({required this.errorMessage});
}