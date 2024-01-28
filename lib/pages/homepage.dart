import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/Firebasehelper.dart';
import 'package:flutter_application_6/models/chatRoomModel.dart';
import 'package:flutter_application_6/models/uihelper.dart';
import 'package:flutter_application_6/pages/chatroompage.dart';
import 'package:flutter_application_6/pages/searchpage.dart';

import '../models/usermodel.dart';
import 'loginpage.dart';

class HomePage extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;
  const HomePage(
      {Key? key, required this.userModal, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
        centerTitle: true,
        backgroundColor: Colors.purple,
         automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => LoginPage())));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
          child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("users",arrayContains: widget.userModal.uid).orderBy("createdon")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomsnapshot = snapshot.data as QuerySnapshot;
                return ListView.builder(
                    itemCount: chatRoomsnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomsnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;
                      List<String> participantsKeys =
                          participants.keys.toList();
                      participantsKeys.remove(widget.userModal.uid);
                      return FutureBuilder(
                          future: Firebasehelper()
                              .getUserModelById(participantsKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModal targetuser =
                                    userData.data as UserModal;

                                return ListTile(
                                  onTap: (() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => ChatRoomPage(targetuser: targetuser, chatroom: chatRoomModel, userModal: widget.userModal, firebaseUser: widget.firebaseUser))));
                                  }),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    backgroundImage: NetworkImage(
                                        targetuser.profilepic.toString()),
                                  ),
                                  title: Text(targetuser.fullname.toString()),
                                  subtitle: (chatRoomModel.lastmessage.toString()!="")?Text(
                                      chatRoomModel.lastmessage.toString()):Text("Say hii to your new friend!",
                                      style: TextStyle(color: Colors.purple),),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          });
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return Center(
                  child: Text("No chats"),
                );
              }
            } else {
              return CircularProgressIndicator(
                color: Colors.purple,
              );
            }
          },
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => SearchPage(
                        userModal: widget.userModal,
                        firebaseUser: widget.firebaseUser,
                      ))));
        },
        child: Icon(Icons.search),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
