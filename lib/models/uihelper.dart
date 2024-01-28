

import 'package:flutter/material.dart';

class UIHelper{
static  void showLoadingDialog(BuildContext context,String title){
  AlertDialog LoadingDialog=AlertDialog(
    content: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        CircularProgressIndicator(backgroundColor: Colors.purple,),
        SizedBox(height: 30,),
        Text(title),
      ]),
    ),

  );
  showDialog(
    context: context,
    barrierDismissible: false,
     builder: (context){
    return LoadingDialog;
  });
}
}