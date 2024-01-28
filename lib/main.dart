import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_6/Firebasehelper.dart';
import 'package:flutter_application_6/firebase_options.dart';
import 'package:flutter_application_6/models/usermodel.dart';
import 'package:flutter_application_6/pages/completeprofilepage.dart';
import 'package:flutter_application_6/pages/homepage.dart';
import 'package:flutter_application_6/pages/loginpage.dart';
import 'package:flutter_application_6/pages/signuppage.dart';
import 'package:flutter_application_6/splashscreen.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';


  var uuid = Uuid();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

 User? currentUser=FirebaseAuth.instance.currentUser;
 

 if(currentUser !=null){
  UserModal? thisUserModel=await Firebasehelper().getUserModelById(currentUser.uid);
  if(thisUserModel!=null){
     runApp( MyAppLoggedIn(userModal: thisUserModel, firebaseUser: currentUser,));


  }else{
     runApp( MyApp());
  }
 
 }else{
  runApp( MyApp());

 }
  
}
//not logged in
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
   
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//already logged in
class MyAppLoggedIn extends StatelessWidget {
  final UserModal userModal;
  final User firebaseUser;

  const MyAppLoggedIn({super.key, required this.userModal, required this.firebaseUser});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
   
      home:  HomePage(firebaseUser: firebaseUser, userModal: userModal,),
      debugShowCheckedModeBanner: false,
    );
  }
}

