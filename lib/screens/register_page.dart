import 'package:electronic_app/constants.dart';
import 'package:electronic_app/widgets/custom_btn.dart';
import 'package:electronic_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context:context,
    barrierDismissible: false,
    builder: (context){
       return AlertDialog(
         title: Text("Error") ,
         content: Container(
           child: Text(error),
         ),
         actions: <Widget>[
           FlatButton(
             child: Text("Close Dialog"),
             onPressed: (){
               Navigator.pop(context);
             },
           )
         ],
       );
    });
  }

   Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _regEmail, password: _regPassword);
      return null;
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        return'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return'The account already exists for that email.';
      }
      return e.message;
    }
    catch(e){
      return e.toString();
    }

   }

   void _submitForm() async {
     setState(() {
       _registerFormLoading = true;
     });
     String _createAccountFeedback = await _createAccount();
     if (_createAccountFeedback != null) {
       _alertDialogBuilder(_createAccountFeedback);

       setState(() {
         _registerFormLoading = false;
       });
     } else{
       Navigator.pop(context);
     }
   }

  bool _registerFormLoading = false;

  String _regEmail ="";
  String _regPassword ="";
  FocusNode _passwordFocusNode;
  @override
  void initState() {
   _passwordFocusNode = new FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 28.0,
                  width: 28.0,
                ),Container(padding: EdgeInsets.only(top: 24.0),
                    child: Text("Create A New Account",style: Constants.boldHeading,textAlign: TextAlign.center,)),
                 Column(
                    children: <Widget>[
                      CustomInput(hintText: "Email....",
                      onChanged: (value){
                        _regEmail=value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },),
                      CustomInput(hintText: "Password....",
                      onChanged: (value){
                        _regPassword=value;
                      },
                      focusNode: _passwordFocusNode,
                      isPassword: true,
                      onSubmitted:(value){
                        _submitForm();
                      },),
                      CustomBtn(
                        btnStr: "Create New Account",
                        onPressed: (){
                        _submitForm();
                        },
                        outlineBtn: false,
                        isLoading: _registerFormLoading,
                      ),
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0
                  ),
                  child: CustomBtn(btnStr: "Back to Login",onPressed: (){
                    Navigator.pop(context);
                  },outlineBtn: true,),
                )
              ],
            ),
          ),
        )
    );
  }
}
