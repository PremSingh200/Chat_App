import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/models/uihelper.dart';

import 'package:flutter_application_6/models/usermodel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'homepage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;

  const CompleteProfile({super.key, required this.userModal, required this.firebaseUser});
 

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
   File? imagefile;
    TextEditingController fullnameController=TextEditingController();
  void selectimage(ImageSource source)async{
   XFile? pickedFile= await ImagePicker().pickImage(source: source);

   if(pickedFile!=null){
    cropImage(pickedFile);
   }

  }
  void cropImage(XFile file)async{
    File? croppedImage=await ImageCropper().cropImage(sourcePath: file.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    compressQuality: 15);

    if(croppedImage!=null){
      setState(() {
        imagefile=croppedImage;
      });
    }
  }
  void showPhotoOptions(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: (() {
                Navigator.pop(context);
                selectimage(ImageSource.gallery);
              }),
              leading: Icon(Icons.photo_album),
              title: Text("Select from Gallery"),
            ),
            ListTile(
              onTap: (() {
                Navigator.pop(context);
                 selectimage(ImageSource.camera);
              }),
                 leading: Icon(Icons.camera_alt),
              title: Text("Take a Photo"),
            )
          ],
        ),
      );
    });
  }
  void checkValues(){
    String fullname=fullnameController.text.trim();
    if(fullname==""||imagefile==""){
       showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Please fill all the fields!"),
        );
        
      });
    }else{
      uploaddata();

    }
  }
  void uploaddata()async{
    UIHelper.showLoadingDialog(context, "Uploading Image...");
    UploadTask uploadTask=FirebaseStorage.instance.ref("profilepictures").child(widget.userModal.uid.toString()).putFile(imagefile!);

    TaskSnapshot snapshot=await uploadTask;
    String? imageUrl=await snapshot.ref.getDownloadURL();
    String? fullname=fullnameController.text.trim();

    widget.userModal.fullname=fullname;
    widget.userModal.profilepic=imageUrl;

    await FirebaseFirestore.instance.collection("users").doc(widget.userModal.uid).set(widget.userModal.toMap()).then((value) {
      //print("Data Uploaded");
       showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Data Uploaded")
        );
      });
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return HomePage(firebaseUser: widget.firebaseUser, userModal: widget.userModal,);
      }));
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile"),
      centerTitle: true,backgroundColor: Colors.purple,
      automaticallyImplyLeading: false,),
      body: SafeArea(child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(children: [
          SizedBox(height: 20,),
          CupertinoButton(
            onPressed: (){
              showPhotoOptions();
            },
            padding: EdgeInsets.all(0),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: (imagefile!=null)?FileImage(imagefile!):null,
              child: (imagefile==null)?Icon(Icons.person,size: 60,color: Colors.white,):null,
              backgroundColor: Colors.purple,),
          ),
             SizedBox(height: 20,),
             TextField(
              controller: fullnameController,
                decoration: InputDecoration(labelText: "Full Name",labelStyle: TextStyle(color: Colors.purple),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple
                  )
                )),
                
              ),
                SizedBox(height: 30,),
               CupertinoButton(child: Text("Submit"), onPressed: (){
                checkValues();
               },color: Colors.purple,)
        ]),
      )
      ),
    );
  }
}