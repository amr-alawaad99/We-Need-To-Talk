import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


// DEFAULT BUTTON
Widget defaultButton({
  double width = double.infinity,
  double height = 50.0,
  double borderRadius = 10.0,
  Color buttonColor = Colors.deepPurpleAccent,
  required Function() onPressedFunction,
  required String text,
  Color textColor = Colors.white,
  double fontSize = 15.0,
  bool isUpperCase = true,

}) => Container(
  width: width,
  height: height,
  
  decoration: BoxDecoration(
    borderRadius: BorderRadiusDirectional.circular(borderRadius),
    color: buttonColor,
  ),
  child: MaterialButton(
    onPressed: onPressedFunction,
    child: Text(
      isUpperCase? text.toUpperCase() : text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
    ),
  ),
);
///////////////////////////

// DEFAULT TEXT FROM FIELD
Widget defaultTextFromField({
  required TextEditingController controller,
  required TextInputType inputType,
  required IconData prefixIcon,
  IconData? suffixIcon,
  Function()? suffixPressFunction,
  bool isObscure = false,
  String? label,
  Function(String value)? onFieldSubmitted,
  String? Function(String? value)? validator,
  double borderRadius = 4.0,
  String? hintText,
  bool isLabel = true,

}) => TextFormField(
  controller: controller,
  keyboardType: inputType,
  obscureText: isObscure,
  decoration: InputDecoration(
    prefixIcon: Icon(
      prefixIcon,
    ),
    suffixIcon: suffixIcon != null ? IconButton(
      icon: Icon(suffixIcon),
      onPressed: suffixPressFunction,
    ) : null,
    label: isLabel == true? Text(label!) : null,
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  ),
  onFieldSubmitted: onFieldSubmitted,
  validator: validator,
);
///////////////////////////

// Show Toast
void showToast({
  required String message,
  required Color toastColor,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: toastColor,
        textColor: textColor,
        fontSize: fontSize,
    );
///////////////////////////

// Division Line
Widget divider() => Padding(
    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0,),
    child: Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[500],
    ),
  );
///////////////////////////

// Navigate and Push
Future navigatePush(context ,Widget widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget,));
///////////////////////////

