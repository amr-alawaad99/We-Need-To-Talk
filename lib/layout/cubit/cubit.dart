import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
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
    // reversedHallway = [];
    print("Hiiii your uid is $uid");
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      originalUser = UserModel.fromJson(value.data()!);
      print("Hiiii your username is ${originalUser!.username}");
      print('your bio is ${originalUser!.bio}');
      print('your pic url is ${originalUser!.profilePic}');
      emit(GetUserDataSuccessState());
      print("Hallway size: ${readHallway().length}");
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
    FirebaseFirestore.instance.collection('users').doc(uid).update({'token': ''});
    CacheHelper.removeData(key: 'uid').then((value) {
      uid = '';
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
  Future<void> sendMessage({
    required String message,
    required String dateTimeForOrder,
    required String receiverID,
  }) async {

    MessageModel messageModel = MessageModel(
      message: message,
      dateTime: dateTimeForOrder,
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

    String? token;
    await FirebaseFirestore.instance.collection('users').doc(receiverID).get().then((value) {
      token = value.get('token').toString();
    });
    print("Receiver Token is: $token");

    sendPushNotification(token: token!, title: originalUser!.username!, msg: message);

    setHallway(receiverID);
  }
  ///////////////////////////////////

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String msg,
}) async {
    try{
      final body =
      {
        "to": token,
        "notification":
        {
          "title": title,
          "body": msg,
          "sound": "default"
        },
        "android":
        {
          "priority": "HIGH",
          "notification":
          {
            "notificaton_priority": "PRIORITY_MAX",
            "sound": "default",
            "default_sound": true,
            "default_vibrate_timings": true,
            "default_light_settings": true
          }

        },
        "data":
        {
          "type": "order",
          "id": "87",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }

      };

      var res = await post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "key=AAAAUXzbnEA:APA91bGwykYk9c6rI_VDyus4liiIkaNdesE7dTXAsHj2bf_xcIiFu9gqa2JomPvOpJr6t93xVrqXUSE_sbxVA-cl5PPy-SkAfRJ9WeGCGO27IpMTAGAyNae8YTIr_IvTbAy6q17fgL7V"
        },
        body: jsonEncode(body),
      );
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nSendPushNotificationError: $e');
    }
  }



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
          setHallway(receiverID);
          emit(GetMessageSuccessState());
    });
  }
  ///////////////////////////////////

  // Add Hallway List to DB
  void setHallway(String receiverUid) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('chat').doc(element.data()['uid'])
              .collection('messages').orderBy('dateTimeForOrder').get().then((value) {
            if(value.size > 0){
              HallwayCardModel hallwayCardModel = HallwayCardModel(
                senderId: value.docs.last['senderId'],
                endID: element.data()['uid'],
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


      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance.collection('users').doc(receiverUid).collection('chat').doc(element.data()['uid'])
              .collection('messages').orderBy('dateTimeForOrder').get().then((value) {
            if(value.size > 0){
              HallwayCardModel hallwayCardModel = HallwayCardModel(
                senderId: value.docs.last['senderId'],
                endID: element.data()['uid'],
                dateTimeForOrder: value.docs.last['dateTimeForOrder'],
                lastMessage: value.docs.last['message'],
                endName: element.data()['username'],
                endPic: element.data()['picURL'],
              );
              FirebaseFirestore.instance.collection('users').doc(receiverUid).collection('hallway').doc(element.data()['uid']).set(hallwayCardModel.toMap());
            }
          });
        }
      }).catchError((error){
        emit(GetHallwayListErrorState(error.toString()));
      });

  }
  ///////////////////////////////////

  // Get Hallway List from DB irt
  // List<HallwayCardModel> reversedHallway = [];
  // void getHallway(){
  //   setHallway();
  //   FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('hallway').orderBy('dateTimeForOrder')
  //       .snapshots().listen((event) {
  //     List<HallwayCardModel> hallwayList = [];
  //     reversedHallway = [];
  //     for (var element in event.docs) {
  //       getMessages(receiverID: element.data()['endID']);
  //       hallwayList.add(HallwayCardModel.fromJson(element.data()));
  //     }
  //     reversedHallway = hallwayList.reversed.toList();
  //     emit(GetHallwayListSuccessState());
  //   });
  // }
  ///////////////////////////////////

  Stream<List<HallwayCardModel>> readHallway(){
    return FirebaseFirestore.instance.collection('users').doc(originalUser!.uid).collection('hallway').orderBy('dateTimeForOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => HallwayCardModel.fromJson(doc.data())).toList());
  }


}
