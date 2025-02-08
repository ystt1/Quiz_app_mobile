abstract class ButtonState2{}

class ButtonInitialState2 extends ButtonState2{}

class ButtonLoadingState2 extends ButtonState2{}

class ButtonSuccessState2 extends ButtonState2{
  final String? type;
  final int? index;
  ButtonSuccessState2(this.type,this.index);
}

class ButtonFailureState2 extends ButtonState2{
  final String errorMessage;

  ButtonFailureState2({required this.errorMessage});
}