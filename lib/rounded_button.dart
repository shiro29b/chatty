import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({ required this.color,required this.title,required this.onpressed});

  final Color color;
  final String title;
  final Function onpressed;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(

          minWidth: 200.0,
          height: 42.0,
          child: Text(title,),
          onPressed: (){
            onpressed();
          },
        ),
      ),
    );
  }
}


// Navigator.pushNamed(context, onPress);