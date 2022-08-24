import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({required this.onpressed,required this.title,Key? key}) : super(key: key);
 final String title;
 final VoidCallback onpressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        color:  Colors.deepOrangeAccent,
        onPressed: onpressed,
      child:Text(title,style: const TextStyle(color: Colors.white),) ,),
    );
  }
}
