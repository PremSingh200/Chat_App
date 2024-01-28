import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/main.dart';
import 'package:flutter_application_6/models/chatRoomModel.dart';
import 'package:flutter_application_6/models/messagemodel.dart';
import 'package:flutter_application_6/models/usermodel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModal targetuser;
  final ChatRoomModel chatroom;
  final UserModal userModal;
  final User firebaseUser;
  const ChatRoomPage(
      {Key? key,
      required this.targetuser,
      required this.chatroom,
      required this.userModal,
      required this.firebaseUser})
      : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModal.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

          widget.chatroom.lastmessage=msg;
          FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatroom.chatroomid).set(widget.chatroom.toMap());

      log("message sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              backgroundImage:
                  NetworkImage(widget.targetuser.profilepic.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.targetuser.fullname.toString())
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            //This is where chat will go
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatroomid)
                      .collection("messages").orderBy("createdon",descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          reverse: true,
                          itemCount: datasnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                datasnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender==widget.userModal.uid)?MainAxisAlignment.end:MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(color:(currentMessage.sender==widget.userModal.uid)?Colors.grey: Colors.purple,
                                  borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: TextStyle(color: Colors.white),)),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occured!Please check your internet connection."),
                        );
                      } else {
                        return Center(
                          child: Text("Say hii to your new friend"),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(backgroundColor: Colors.purple,),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                      child: TextField(
                    controller: messageController,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter message"),
                  )),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.purple,
                      ))
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
