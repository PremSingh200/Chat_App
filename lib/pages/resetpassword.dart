
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/pages/loginpage.dart';



class ResetPasswordScreen extends StatelessWidget {
 ResetPasswordScreen({Key? key}) : super(key: key);
  TextEditingController Controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Reset Page",style: TextStyle(color: Colors.purple,fontSize: 30,fontWeight: FontWeight.bold),),
            Padding(padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: Controller,
              decoration: InputDecoration(
                labelText: "Enter your Email-id",
                 labelStyle: TextStyle(color: Colors.purple),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
              ),

            )),
            SizedBox(height:10),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.sendPasswordResetEmail(email: Controller.text).then((value) {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));

              });
            }, child: Text("Reset Password"),style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            minimumSize: const Size(double.infinity,50),
            primary: Colors.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            )
           ),)


          ]),
        ),
      ),

    );
  }
}