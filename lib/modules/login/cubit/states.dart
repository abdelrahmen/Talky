abstract class LoginStates {}

class LoginInitialState extends LoginStates{}

class LoginSuccessfulState extends LoginStates{}

class LoginErrorState extends LoginStates{
  var error;
  LoginErrorState(this.error);
}
class LoginLoadingState extends LoginStates{}

class ChangePassVisibilityState extends LoginStates{}
