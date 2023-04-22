import 'package:we_need_to_talk/model/user_model.dart';

class HallwayCardModel {
  String? senderId;
  String? lastMessage;
  String? dateTimeForShow;
  String? dateTimeForOrder;
  String? endID;
  String? endName;
  String? endPic;

  HallwayCardModel({
    this.senderId,
    this.lastMessage,
    this.dateTimeForShow,
    this.endID,
    this.endName,
    this.endPic,
    this.dateTimeForOrder,
  });

  HallwayCardModel.fromJson(Map<String, dynamic> json){
    senderId = json['senderId'];
    lastMessage = json['lastMessage'];
    dateTimeForShow = json['dateTimeForShow'];
    dateTimeForOrder = json['dateTimeForOrder'];
    endID = json['endID'];
    endName = json['endName'];
    endPic = json['endPic'];
  }

  Map<String, dynamic> toMap(){
    return{
      'lastMessage' : lastMessage,
      'senderId' : senderId,
      'dateTimeForShow' : dateTimeForShow,
      'dateTimeForOrder' : dateTimeForOrder,
      'endID' : endID,
      'endName' : endName,
      'endPic' : endPic,
    };
  }
}
