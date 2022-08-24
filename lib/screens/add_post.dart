import 'dart:io';

import 'package:blog/shared/widget/roud_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool showSpinner = false;
  final blogRef = FirebaseDatabase.instance.ref().child('Blogs');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  File? image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Future getImageCamera() async {
    final pickedfiler = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedfiler != null) {
        image = File(pickedfiler.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future getImageGallery() async {
    final pickedfiler = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfiler != null) {
        image = File(pickedfiler.path);
      } else {
        print('no image slected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text('camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallrey'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          title: const Text('Add blog'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                        height: 200,
                        width: 350,
                        //  height: MediaQuery.of(context).size.height*2,
                        //width: MediaQuery.of(context).size.width*1,
                        child: image != null
                            ? ClipRect(
                                child: Image.file(
                                  image!.absolute,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue,
                                ),
                              )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'must not be  empty';
                            }
                          },

                          controller: titleController,
                          //minLines:1 ,
                          //maxLines: 5,
                          //maxLength:5 ,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              label: const Text('Title'),
                              hintText: 'Enter blog title',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'must not be  empty';
                            }
                          },
                          controller: descriptionController,
                          maxLines: null,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              label: const Text('description'),
                              hintText: 'Enter blog description',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                              labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundButton(
                            onpressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  int data =
                                      DateTime.now().microsecondsSinceEpoch;
                                  firebase_storage.Reference ref =
                                      firebase_storage.FirebaseStorage.instance
                                          .ref('/blog$data');
                                  UploadTask uploadTaske =
                                      ref.putFile(image!.absolute);
                                  await Future.value(uploadTaske);
                                  var newUrl = await ref.getDownloadURL();
                                  final User? user = auth.currentUser;
                                  blogRef
                                      .child('Blog List')
                                      .child(data.toString())
                                      .set({
                                    'pId': data.toString(),
                                    'pImage': newUrl.toString(),
                                    'pTitle': titleController.text.toString(),
                                    'pDescrption': descriptionController.text.toString(),
                                    'uEmail':user!.email.toString(),
                                    'uId':user.uid.toString(),
                                  }).then((value) {
                                    showtoast('Blog Published');
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  }).onError((error, stackTrace) {
                                    showtoast(error.toString());
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  });
                                } catch (e) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  showtoast(e.toString());
                                }
                              }
                            },
                            title: 'save')
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showtoast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
