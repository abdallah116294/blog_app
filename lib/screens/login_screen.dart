import 'package:blog/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../shared/widget/roud_button.dart';

class LoginScreen  extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  bool showSpinner=false;
  var formKey=GlobalKey<FormState>();
  String? email,password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login to your account  '),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
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
                              final user=await firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                              if(user !=null)
                              {
                                print("success");
                                showtoast("success");
                                setState((){
                                  showSpinner=false;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return HomeScreen();
                                }));
                              }
                            }catch(e){
                              print(e.toString());
                              showtoast(e.toString());
                              setState((){
                                showSpinner=false;
                              });
                            }
                           }
                        }, title: 'Login ')
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
