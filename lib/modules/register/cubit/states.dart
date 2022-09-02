abstract class RegisterState{}

class RegisterInitialState extends RegisterState{}

class RegisterLoadingState extends RegisterState{}

class RegisterSuccessfulState extends RegisterState{}

class RegisterErrorState extends RegisterState{
  var error;
  RegisterErrorState(this.error);
}

class ChangePassVisibilityState extends RegisterState{}