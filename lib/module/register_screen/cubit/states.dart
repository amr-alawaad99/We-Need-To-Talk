abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}

class PasswordVisibilityChangeState extends RegisterStates{}

////////////////////////


// New User Authentication
class RegisterUserLoadingState extends RegisterStates{}
class RegisterUserSuccessState extends RegisterStates{
  final String uid;

  RegisterUserSuccessState(this.uid);
}
class RegisterUserErrorState extends RegisterStates{
  final String error;

  RegisterUserErrorState(this.error);
}
////////////////////////

// Create User Firebase Data
class CreateUserLoadingState extends RegisterStates{}
class CreateUserSuccessState extends RegisterStates{}
class CreateUserErrorState extends RegisterStates{
  final String error;

  CreateUserErrorState(this.error);
}
////////////////////////

