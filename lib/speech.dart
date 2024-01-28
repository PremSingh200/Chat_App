


import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  var _speechtotext=stt.SpeechToText();
  bool islistening=false;
  String text="Please press to speak";
  void listen() async{
    if(!islistening){
    bool available=await  _speechtotext.initialize(
        onStatus: (status) => print("$status"),
        onError: (errorNotification)=> print("$errorNotification"),

      );
      if(available){
        setState(() {
          islistening=true;
        });
        _speechtotext.listen(
          onResult: ((result) => setState(() {
            text=result.recognizedWords;
          }))
        );
      }
    }else{
      setState(() {
        islistening=false;
      });
      _speechtotext.stop();
    }


  }
  
  
  @override
  void initState(){
    super.initState();
    _speechtotext=stt.SpeechToText();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech to Text"),
      centerTitle: true,backgroundColor: Colors.purple,),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(text,style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate:islistening,
        repeat:true,
        endRadius: 100,
        glowColor: Colors.green,
        duration: Duration(microseconds: 1000),
        child: FloatingActionButton(
          onPressed: (){
            listen();
          },
          backgroundColor: Colors.purple,
          child: Icon(islistening? Icons.mic:Icons.mic_none),
        ),
      ),
    );
  }
}
