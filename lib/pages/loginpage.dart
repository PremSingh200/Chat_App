import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/models/uihelper.dart';
import 'package:flutter_application_6/models/usermodel.dart';
import 'package:flutter_application_6/pages/homepage.dart';
import 'package:flutter_application_6/pages/resetpassword.dart';
import 'package:flutter_application_6/pages/signuppage.dart';

import 'completeprofilepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool _obscuretext = true;
    TextEditingController emailController=TextEditingController();
    TextEditingController passwordController=TextEditingController();
    void checkValues(){
       String email = emailController.text.trim();
      String password=passwordController.text.trim();
          if(email=="" || password==""){
        //print("Please fill all the fields!");
        showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Please fill all the fields!"),
        );
        
      });
      }else{
        logIn(email, password);
      }
    }
    void logIn(String email,String password)async{
      UserCredential? credential;
      UIHelper.showLoadingDialog(context, "Logging In..");
      try{
        credential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      }on FirebaseAuthException catch(e){
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
    showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("No user found for that email."),
        );
        
      });
     
  } else if (e.code == 'wrong-password') {
    showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Wrong Password")
        );
      });
  }
      }
      if (credential!=null){
         String uid=credential.user!.uid;
         DocumentSnapshot userData= await FirebaseFirestore.instance.collection("users").doc(uid).get();
         UserModal userModal=UserModal.fromMap(userData.data() as Map<String,dynamic>);

         print("Login Successfull");
         
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return HomePage(userModal: userModal, firebaseUser: credential!.user!);
      }));
      }
    }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Let's Chat",
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                 keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email Address",
                    labelStyle: TextStyle(color: Colors.purple),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: _obscuretext,
                 keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: (() {
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      }),
                      child: _obscuretext? const Icon(Icons.visibility_off):Icon(Icons.visibility)
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.purple),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple))),
              ),
                const SizedBox(
              height: 10,
            ),
            
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                  }, child: Text("Forgot Password?",style: TextStyle(color: Colors.purple),))),
              
              SizedBox(
                height: 30,
              ),
              CupertinoButton(
                child: Text("Log In"),
                onPressed: () {
                  checkValues();
                },
                color: Colors.purple,
              )
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16),
          ),
          CupertinoButton(
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 16, color: Colors.purple),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => SignUpPage())));
            },
          )
        ],
      )),
    );
  }
}
