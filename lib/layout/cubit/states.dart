import 'package:we_need_to_talk/layout/cubit/cubit.dart';

abstract class ChatAppStates{}

class ChatChangeBottomNavState extends ChatAppStates{}

class ChatAppInitialState extends ChatAppStates{}

class UserLoadingState extends ChatAppStates{}
class UserSuccessState extends ChatAppStates{}
class UserErrorState extends ChatAppStates{
  final String error;

  UserErrorState(this.error);
}



class GetProfileImageLoadingState extends ChatAppStates{}
class GetProfileImageSuccessState extends ChatAppStates{}
class GetProfileImageErrorState extends ChatAppStates{}

class GetUserDataLoadingState extends ChatAppStates{}
class GetUserDataSuccessState extends ChatAppStates{}
class GetUserDataErrorState extends ChatAppStates{
  final String error;

  GetUserDataErrorState(this.error);
}

class UpdateUserDataLoadingState extends ChatAppStates{}
class UpdateUserDataSuccessState extends ChatAppStates{}
class UpdateUserDataErrorState extends ChatAppStates{
  final String error;

  UpdateUserDataErrorState(this.error);
}

class UploadProfilePicLoadingState extends ChatAppStates{}
class UploadProfilePicSuccessState extends ChatAppStates{}
class UploadProfilePicErrorState extends ChatAppStates{
  final String error;

  UploadProfilePicErrorState(this.error);
}


class SignOutSuccessState extends ChatAppStates{}


class SearchUserSuccessState extends ChatAppStates{}
class SearchUserErrorState extends ChatAppStates{
  final String error;

  SearchUserErrorState(this.error);
}

class ManageFriendListLoadingState extends ChatAppStates{}
class AddToFriendListSuccessState extends ChatAppStates{}
class RemoveFromFriendListSuccessState extends ChatAppStates{}
class ManageFriendListErrorState extends ChatAppStates{
  final String error;

  ManageFriendListErrorState(this.error);
}

class GetFriendsListLoadingState extends ChatAppStates{}
class GetFriendsListSuccessState extends ChatAppStates{}
class GetFriendsListErrorState extends ChatAppStates{
  final String error;

  GetFriendsListErrorState(this.error);
}

class SendMessageSuccessState extends ChatAppStates{}
class SendMessageErrorState extends ChatAppStates{
  final String error;

  SendMessageErrorState(this.error);
}

class GetMessageSuccessState extends ChatAppStates{}

class GetHallwayListSuccessState extends ChatAppStates{}
class GetHallwayListErrorState extends ChatAppStates{
  final String error;

  GetHallwayListErrorState(this.error);
}