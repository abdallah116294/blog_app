
import 'package:blog/screens/signin_screen.dart';
import 'package:flutter/material.dart';

import '../shared/widget/roud_button.dart';
import 'login_screen.dart';

class OptionScreen  extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const   Image(image: AssetImage('assets/images/download.png'),),
              SizedBox(height: 10,),
              RoundButton(title: "Login",onpressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }));
              } ,),
             const  SizedBox(height: 30,),
              RoundButton(title: "Register",onpressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SignInScreen();
                }));
              } ,)
            ],
          ),
        ),
      ),
    );
  }
}
