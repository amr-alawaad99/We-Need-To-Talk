class MessageModel {
  String? message;
  String? dateTime;
  String? senderId;
  String? receiverId;

  MessageModel({
    this.message,
    this.dateTime,
    this.senderId,
    this.receiverId,
  });

  MessageModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    dateTime = json['dateTimeForOrder'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toMap(){
    return{
      'message' : message,
      'dateTimeForOrder' : dateTime,
      'senderId' : senderId,
      'receiverId' : receiverId,
    };
  }
}
