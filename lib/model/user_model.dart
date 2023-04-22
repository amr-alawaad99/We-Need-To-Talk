class UserModel {
  String? username;
  String? phone;
  String? uid;
  String? bio;
  String? profilePic;
  bool? isFriend;

  UserModel({
    this.username,
    this.phone,
    this.uid,
    this.bio,
    this.profilePic,
    this.isFriend,
});

  UserModel.fromJson(Map<String, dynamic> json){
    username =json['username'];
    phone =json['phone'];
    uid =json['uid'];
    bio =json['bio'];
    profilePic =json['picURL'];
    isFriend = json['isFriend'];
  }

  Map<String, dynamic> toMap(){
    return {
      'username' : username,
      'phone' : phone,
      'uid' : uid,
      'bio' : bio,
      'picURL' : profilePic,
      'isFriend' : isFriend,
    };
  }

}