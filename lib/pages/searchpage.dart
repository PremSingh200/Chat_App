import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_application_6/models/usermodel.dart';


import '../main.dart';
import '../models/chatRoomModel.dart';
import 'chatroompage.dart';

class SearchPage extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;

  const SearchPage({super.key, required this.userModal, required this.firebaseUser});
  

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController=TextEditingController();
  ChatRoomModel? chatroom;
  Future<ChatRoomModel?>getChatRoomModel(UserModal targetuser)async{
   QuerySnapshot snapshot= await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModal.uid}",isEqualTo: true).where("participants.${targetuser.uid}",isEqualTo: true).get();

   if(snapshot.docs.length >0){
    //Fetch the existing one
     var docData =snapshot.docs[0].data();
      ChatRoomModel existingchatroom=ChatRoomModel.fromMap(docData as Map<String,dynamic>);
      chatroom=existingchatroom;
    log("chatroom already created");
   }else{
    //create new one 
    ChatRoomModel newchatroom=ChatRoomModel(chatroomid: uuid.v1(),
    lastmessage: "",
    createdon: DateTime.now(),
   participants: {
    widget.userModal.uid.toString():true,
    targetuser.uid.toString():true
   },
   users: [widget.userModal.uid.toString(),targetuser.uid.toString()]
    
      
    );
    await FirebaseFirestore.instance.collection("chatrooms").doc(newchatroom.chatroomid).set(newchatroom.toMap());
    chatroom=newchatroom;
       log("new chatroom created");
   }
   return chatroom;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("Search"),centerTitle: true,backgroundColor: Colors.purple,),
      body: SafeArea(child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
          children: [
            SizedBox(height: 10,),
           TextField(
                controller: searchController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Enter fullname",
                   labelStyle: TextStyle(color: Colors.purple),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                ),
      
              ),
                 SizedBox(height: 10,),
                   CupertinoButton(child: Text("Search"), onPressed: (){
                    setState(() {
                      
                    });
                 },color: Colors.purple,),
                  SizedBox(height: 20,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").where("fullname",isEqualTo: searchController.text,isNotEqualTo: widget.userModal.email).snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.active){
                        if(snapshot.hasData){
                          QuerySnapshot datasnapshot=snapshot.data as QuerySnapshot;
      
                          if(datasnapshot.docs.length>0){
                                 Map<String,dynamic>userMap=datasnapshot.docs[0].data() as Map<String,dynamic>;
                          UserModal searcheduser=UserModal.fromMap(userMap);
      
                          return ListTile(
                            onTap: (() async{
                            ChatRoomModel? chatRoomModel= await getChatRoomModel(searcheduser);
                            if(ChatRoomModel!=null){
                                Navigator.pop(context);
                                   Navigator.push(context,MaterialPageRoute(builder: ((context) => ChatRoomPage(
                                    targetuser: searcheduser,
                                    userModal: widget.userModal,
                                    firebaseUser: widget.firebaseUser,
                                    chatroom:chatRoomModel!,
                                   ))));
                            }
                           
                            }),
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              backgroundImage: NetworkImage(searcheduser.profilepic!),),
                            title: Text(searcheduser.fullname!),
                            subtitle: Text(searcheduser.email!),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          );
      
                          }else{
                             return Text("No results found!");
                          }
      
                     
                        }else if(snapshot.hasError){
                            return Text("An error occured");
                        }else{
                          return Text("No results found!");
                        }
      
                      }else{
                        return CircularProgressIndicator();
                      }
                    })
          ],
        ),),
      )),
    );
  }
}