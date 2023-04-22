import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/model/message_model.dart';
import 'package:we_need_to_talk/module/calls_screen/calls_screen.dart';
import 'package:we_need_to_talk/module/friends_screen/friends_screen.dart';
import 'package:we_need_to_talk/module/hallway_screen/hallway_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:we_need_to_talk/shared/components/constants.dart';
import '../../model/hallway_model.dart';
import '../../model/user_model.dart';
import '../../shared/local/cache_helper.dart';

class ChatAppCubit extends Cubit<ChatAppStates> {
  ChatAppCubit() : super(ChatAppInitialState());

  static ChatAppCubit get(context) => BlocProvider.of(context);

  //  Cubit for BottomNavBar
  int currentIndex = 0;

  void changeBottomNav(int index) {
      currentIndex = index;
      emit(ChatChangeBottomNavState());
  }

  List<Widget> screens = [
    const HallWayScreen(),
    const FriendsScreen(),
    const CallsScreen(),
  ];

  List<String> titles = [
    'Hallway',
    'Friends',
    'Calls',
  ];

  // Choose Pic from device using ImagePicker
  File? profilePic;
  ImagePicker picker = ImagePicker();

  Future<void> getProfilePic() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profilePic = File(image.path);
      emit(GetProfileImageSuccessState());
    } else {
      print('get profile image ERROR!');
      emit(GetProfileImageErrorState());
    }
  }
  ///////////////////////////////////

  // Upload picked picture to Firebase storage
  void uploadProfilePic({
    String? name,
    String? bio,
  }) {
    emit(UploadProfilePicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/profile_pictures/$uid/${Uri.file(profilePic!.path).pathSegments.last}')
        .putFile(profilePic!)
        .then((value) {
      value.ref.getDownloadURL().then((value2) {
        updateUserProfile(
          profilePic: value2,
          name: name,
          bio: bio,
        );
      }).catchError((error) {
        print('1:');
        emit(UploadProfilePicErrorState(error.toString()));
      });
    }).catchError((error) {
      print("2:");
      emit(UploadProfilePicErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  // Putting data from the FireBase FireStore into The UserModel Model
  UserModel? originalUser;
  void getUserData() {
    emit(GetUserDataLoadingState());

    print("Hiiii your uid is $uid");
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      originalUser = UserModel.fromJson(value.data()!);
      print("Hiiii your username is ${originalUser!.username}");
      print('your bio is ${originalUser!.bio}');
      print('your pic url is ${originalUser!.profilePic}');
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      emit(GetUserDataErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  // updating user data in FireStore then in the UserModel
  void updateUserProfile({
    String? name,
    String? bio,
    String? profilePic,
  }) {
    UserModel updatedModel = UserModel(
      username: name,
      bio: bio,
      profilePic: profilePic ?? originalUser!.profilePic,
      uid: originalUser!.uid,
      phone: originalUser!.phone,
      isFriend: originalUser!.isFriend,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(updatedModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(UpdateUserDataErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  // SingOut
  void singOut() {
    CacheHelper.removeData(key: 'uid').then((value) {
      emit(SignOutSuccessState());
    });
  }
  ///////////////////////////////////

  //List of search result users
  List<UserModel> usersFound = [];

  void findUsers({
    required String searchUser,
  }) {
    usersFound = [];
    if (usersFound.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element
                  .data()['username']
                  .toString()
                  .replaceAll(' ', '')
                  .toUpperCase()
                  .contains(searchUser.toUpperCase()) &&
              searchUser != '') {
            usersFound.add(UserModel.fromJson(element.data()));
            // IF A SEARCHED USERS IS FRIEND => isFriend = true
            friendsList.forEach((element) {
              if (element.uid == usersFound.last.uid) {
                usersFound.last.isFriend = true;
              }
            });
            /////////
          }
        });
        emit(SearchUserSuccessState());
      }).catchError((error) {
        emit(SearchUserErrorState(error.toString()));
      });
    }
  }
  ///////////////////////////////////

  // List of Friends
  IconData addRemove = Icons.person_add;
  void manageFriendList({
    required UserModel model,
    String? search,
  }) {
    emit(ManageFriendListLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(originalUser!.uid)
        .collection('friends')
        .doc(model.uid)
        .get()
        .then((value) {
      if (value.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(originalUser!.uid)
            .collection('friends')
            .doc(model.uid)
            .delete()
            .then((value) {
          if (search != null) {
            findUsers(searchUser: search);
          }
          getFriendList();
        });
        emit(RemoveFromFriendListSuccessState());
      } else if (value.id != originalUser!.uid) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(originalUser!.uid)
            .collection('friends')
            .doc(model.uid)
            .set(model.toMap())
            .then((value) {
          if (search != null) {
            findUsers(searchUser: search);
          }
          getFriendList();
        });
        emit(AddToFriendListSuccessState());
      } else {
        print('u can\'t add yourself dumbdumb!');
      }
    }).catchError((error) {
      emit(ManageFriendListErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  // get FriendList
  List<UserModel> friendsList = [];
  void getFriendList() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(originalUser!.uid)
        .collection('friends')
        .get()
        .then((value) async {
      friendsList = [];
      // IT MUST BE FOR LOOP TO AWAIT, FOREACH DOESN'T CARE ABOUT THE "AWAIT"
      for (var element in value.docs) {
        if (element.data()['uid'] != originalUser!.uid) {
          print(element.data()['uid']);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(element.data()['uid'])
              .get()
              .then((value) {
            friendsList.add(UserModel.fromJson(value.data()!));
          });
        }
      }
      print("Friend List Size is ${friendsList.length}"); //RORORORORORORO
      emit(GetFriendsListSuccessState());
    }).catchError((error) {
      emit(GetFriendsListErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  //Send Message to DB
  void sendMessage({
    required String message,
    required String dateTimeForOrder,
    required String dateTimeForShow,
    required String receiverID,
  }){

    MessageModel messageModel = MessageModel(
      message: message,
      dateTimeForOrder: dateTimeForOrder,
      dateTimeForShow: dateTimeForShow,
      senderId: originalUser!.uid,
      receiverId: receiverID,
    );

    FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('chat').doc(receiverID).collection('messages').add(messageModel.toMap()).then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error){
      emit(SearchUserErrorState(error.toString()));
    });

    FirebaseFirestore.instance.collection('users').doc(receiverID).collection('chat').doc(originalUser!.uid).collection('messages').add(messageModel.toMap()).then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    setHallway();
  }
  ///////////////////////////////////

  // Get Messages from DB
  List<MessageModel> reversedChat = [];
  void getMessages({
    required String receiverID,
}){
    FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('chat').doc(receiverID).collection('messages')
        .orderBy('dateTimeForOrder').snapshots().listen((event) {
          List<MessageModel> messages = [];
          reversedChat = [];
          for (var element in event.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
          reversedChat = messages.reversed.toList();
          setHallway();
          emit(GetMessageSuccessState());
    });
  }
  ///////////////////////////////////

  // Add Hallway List to DB
  void setHallway() {
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('chat').doc(element.data()['uid'])
            .collection('messages').orderBy('dateTimeForOrder').get().then((value) {
          if(value.size > 0){
            HallwayCardModel hallwayCardModel = HallwayCardModel(
              senderId: value.docs.last['senderId'],
              endID: element.data()['uid'],
              dateTimeForShow: value.docs.last['dateTimeForShow'],
              dateTimeForOrder: value.docs.last['dateTimeForOrder'],
              lastMessage: value.docs.last['message'],
              endName: element.data()['username'],
              endPic: element.data()['picURL'],
            );
            FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('hallway').doc(element.data()['uid']).set(hallwayCardModel.toMap());
          }
        });
      }
    }).catchError((error){
      emit(GetHallwayListErrorState(error.toString()));
    });
  }
  ///////////////////////////////////

  // Get Hallway List from DB irt
  List<HallwayCardModel> reversedHallway = [];
  void getHallway(){
    setHallway();
    FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('hallway').orderBy('dateTimeForOrder')
        .snapshots().listen((event) {
      List<HallwayCardModel> hallwayList = [];
      reversedHallway = [];
      for (var element in event.docs) {
        getMessages(receiverID: element.data()['endID']);
        hallwayList.add(HallwayCardModel.fromJson(element.data()));
      }
      reversedHallway = hallwayList.reversed.toList();
      emit(GetHallwayListSuccessState());
    });
  }
  ///////////////////////////////////


}