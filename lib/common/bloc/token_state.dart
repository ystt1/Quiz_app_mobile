abstract class TokenState{
}
class TokenInitial extends TokenState {

}
class TokenFailure extends TokenState{
  final String error;

  TokenFailure({required this.error});
}

class TokenSuccess extends TokenState{
}