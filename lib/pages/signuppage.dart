

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/models/usermodel.dart';
import 'package:flutter_application_6/pages/completeprofilepage.dart';
import 'package:flutter_application_6/pages/loginpage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
   bool _obscuretext = true;
   TextEditingController emailController=TextEditingController();
    TextEditingController passwordController=TextEditingController();
     TextEditingController cpasswordController=TextEditingController();
     void checkValues(){
      String email = emailController.text.trim();
      String password=passwordController.text.trim();
      String cpassword=cpasswordController.text.trim();

      if(email=="" || password==""||cpassword==""){
        //print("Please fill all the fields!");
        showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Please fill all the fields!"),
        );
        
      });
      }else if(password !=cpassword){
        //print("Password doesn't match");
        showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Password doesn't match"),
        );
        
      });
      }else{
        signUp(email, password);
      }
     }
     void signUp(String email , String password)async{
      UserCredential? credential;
      try{
         credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      }on FirebaseAuthException catch(e){
        if (e.code == 'email-already-in-use') {
    showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("The account already exists for that email."),
        );
        
      });
     
  } 
       
      }
      if (credential!=null){
        String uid=credential.user!.uid;
        UserModal newUser=UserModal(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: ""
        );
        await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
            showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("New User Created!"),
        );
        
        
      });
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return CompleteProfile(userModal: newUser, firebaseUser: credential!.user!);
      }));
        });
      }

     

     }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(child: Column(
            children: [
              Text("Let's Chat",style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold,fontSize: 45,fontStyle: FontStyle.italic),),
            
             SizedBox(height: 10,),
              TextField(
                controller: emailController,
                 keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email Address",labelStyle: TextStyle(color: Colors.purple),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple
                  )
                )),
              ),
              SizedBox(height: 10,),
               TextField(
                controller: passwordController,
                obscureText: _obscuretext,
                 keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: "Password",labelStyle: TextStyle(color: Colors.purple),
                 suffixIcon: GestureDetector(
                      onTap: (() {
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      }),
                      child: _obscuretext? const Icon(Icons.visibility_off):Icon(Icons.visibility)
                    ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple
                  )
                )),
              ),
                SizedBox(height: 10,),
               TextField(
                controller: cpasswordController,
                obscureText: _obscuretext,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(labelText: "Confirm Password",labelStyle: TextStyle(color: Colors.purple),
                
                 suffixIcon: GestureDetector(
                  
                      onTap: (() {
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      }),
                      child: _obscuretext? const Icon(Icons.visibility_off):Icon(Icons.visibility)
                    ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple
                  )
                )),
              ),
               SizedBox(height: 30,),
               CupertinoButton(child: Text("Sign Up"), onPressed: (){
               checkValues();
               },color: Colors.purple,)
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already have an account?",style: TextStyle(fontSize: 16),),
           CupertinoButton(child: Text("Log In",style: TextStyle(fontSize: 16,color: Colors.purple),), onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: ((context) => LoginPage())));
           },)
        ],
      )),
    );
  }
}