class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
String? lastmessage;
 DateTime? createdon;
 List<dynamic>? users;

  ChatRoomModel({this.chatroomid,this.participants,this.lastmessage,this.createdon,this.users});
  ChatRoomModel.fromMap(Map<String,dynamic>map){
    chatroomid=map["chatroomid"];
    participants=map["participants"];
   lastmessage=map["lastmessage"];
   createdon=map["createdon"].toDate();
   users=map["users"];
  }

   Map<String,dynamic> toMap(){
    return{
     "chatroomid":chatroomid,
     "participants":participants,
     "lastmessage":lastmessage,
      "createdon":createdon,
      "users":users
    };
  }
}