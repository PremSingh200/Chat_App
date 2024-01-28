class UserModal{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModal({this.uid,this.fullname,this.email,this.profilepic});

  UserModal.fromMap(Map<String,dynamic> map){
    uid=map["uid"];
    fullname=map["fullname"];
    email=map["email"];
    profilepic=map["profilepic"];
  }

  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "fullname":fullname,
      "email":email,
      "profilepic":profilepic,
    };
  }
}