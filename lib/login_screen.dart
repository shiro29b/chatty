import 'package:chatty/constants.dart';
import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth  _auth =FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  final formKey = GlobalKey<FormState>();

  signMeIn(){
    if(formKey.currentState!.validate())
    {}
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 200),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Form(
                  key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                          onChanged: (value) {
                            //Do something with the user input.
                            email=value;
                          },
                          validator: (value){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ? null: 'Invalid Format';
                          },
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Email Id'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                          onChanged: (value) {
                            //Do something with the user input.
                            password=value;
                          },
                          validator: (value){
                            return value!.length >6 ? null : 'provide more than 6 characters';
                          },
                          decoration: kTextFieldDecoration.copyWith(hintText: 'Enter password'),
                        ),
                      ],
                    )
                ),

                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    title: 'Log In',
                  onpressed: () async {
                    signMeIn();
                      setState(() {
                        showSpinner=true;
                      });

                      try {
                        final UserCredential user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, '/chat');
                        }
                      }
                      catch(e) {
                      print(e.toString());
                    }

                    setState(() {
                      showSpinner=false;
                    });

                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}