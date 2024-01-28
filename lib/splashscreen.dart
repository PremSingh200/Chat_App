import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_6/pages/loginpage.dart';
import 'package:flutter_application_6/speech.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3),() {
       Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => LoginPage())));
    }  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Text("Let's Chat",style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
            SizedBox(height: 30,),
            SpinKitCubeGrid(
                          color: Colors.white,
                          size: 50.0,
                          
                        )

          ],
        ),
      ),
    );
  }
}