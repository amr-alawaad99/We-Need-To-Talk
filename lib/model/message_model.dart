class MessageModel {
  String? message;
  String? dateTimeForOrder;
  String? dateTimeForShow;
  String? senderId;
  String? receiverId;

  MessageModel({
    this.message,
    this.dateTimeForOrder,
    this.dateTimeForShow,
    this.senderId,
    this.receiverId,
  });

  MessageModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    dateTimeForOrder = json['dateTimeForOrder'];
    dateTimeForShow = json['dateTimeForShow'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toMap(){
    return{
      'message' : message,
      'dateTimeForOrder' : dateTimeForOrder,
      'dateTimeForShow' : dateTimeForShow,
      'senderId' : senderId,
      'receiverId' : receiverId,
    };
  }
}
