import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_6/models/usermodel.dart';

class Firebasehelper{
  Future<UserModal?>getUserModelById(String uid)async{
    UserModal? userModel;
    DocumentSnapshot docsnap= await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if(docsnap.data()!=null){
      userModel=UserModal.fromMap(docsnap.data() as Map<String,dynamic>);

    }
    return userModel;
  }
}