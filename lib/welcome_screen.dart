import 'login_screen.dart';
import 'registration_screen.dart';
import 'rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller= AnimationController(
        duration: Duration(seconds: 2 ),
        vsync: this,

    );

    animation= ColorTween(begin: Colors.black54,end: Colors.white).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {

      });
    });

  }

  void onpressLogin(){
    Navigator.pushNamed(context, '/login',);

  }
  void onpressRegister(){
    Navigator.pushNamed(context, '/registration',);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('Flash Chat',textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      ),
                    ],
                    isRepeatingAnimation: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              title: 'Log In',
              onpressed: (){
                onpressLogin();
              },
            ),

            RoundedButton(
              color: Colors.blueAccent,
              title: 'Register',
              onpressed: (){
                onpressRegister();
                },
            ),

          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}

