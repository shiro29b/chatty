import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class RegistrationScreen extends StatefulWidget {


  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth= FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner= false;
  final formKey = GlobalKey<FormState>();

  signMeUP(){
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
                  key: formKey ,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(

                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email=value;
                          },
                          validator: (value){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ? null: 'Invalid Format';
                          },
                          decoration:kTextFieldDecoration.copyWith(hintText: 'Enter Email Id'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
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
                    color: Colors.blueAccent,
                    title: 'Register',
                  onpressed: ()async{
                      signMeUP();
                      setState(() {
                        showSpinner=true;
                      });

                      try {
                        final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        if(newUser!=null)
                          Navigator.pushNamed(context, '/chat');

                      }
                      catch(e){
                        print('e');
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