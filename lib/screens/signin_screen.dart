import 'dart:ffi';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../shared/widget/roud_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
 TextEditingController emailController=TextEditingController();
 TextEditingController passwordController=TextEditingController();
 var formKey=GlobalKey<FormState>();
bool showSpinner=false;
 String? email,password;
 FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      
      inAsyncCall: showSpinner,
      child: Scaffold(

        appBar: AppBar(
          title: Text('create an account '),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
             Text('Register',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                    child: Column(
                  children: [
                    TextFormField(
                      onChanged: (String value){
                        email=value;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String ?value){
                        if(value!.isEmpty)
                          {
                            return 'email must not be empty';
                          }
                      },
                      decoration: InputDecoration(
                        label: Text('Email'),
                        suffixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      ),

                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (String ?value){
                        if(value!.isEmpty)
                        {
                          return 'pass must not be empty';
                        }
                      },
                      decoration: InputDecoration(
                          label: Text('Password'),
                          suffixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )
                      ),

                    ),
                    SizedBox(height: 30,),
                    RoundButton(onpressed: ()async{
                      if(formKey.currentState!.validate())
                        {
                          setState((){
                            showSpinner=true;
                          });
                          try{
                            final user=await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                            if(user !=null)
                              {
                                print("success");
                                showtoast("success");
                                setState((){
                                  showSpinner=false;
                                });
                              }
                          }catch(e){
                          print(e.toString());
                          showtoast(e.toString());
                          setState((){
                            showSpinner=false;
                          });
                          }
                        }
                    }, title: 'Sign in ')
                  ],
                )),
              )
           ],),
        ),
      ),
    );
  }
void showtoast(String message){
    Fluttertoast.showToast(
       msg: message,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0
   );
 }
}
