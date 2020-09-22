import 'package:electronic_app/constants.dart';
import 'package:electronic_app/screens/register_page.dart';
import 'package:electronic_app/widgets/custom_btn.dart';
import 'package:electronic_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage> {

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


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

  Future<String> _loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading = true;
    });
    String _loginFeedback = await _loginAccount();
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    } else{
      Navigator.pop(context);
    }
  }

  bool _loginFormLoading = false;

  String _loginEmail ="";
  String _loginPassword ="";
  FocusNode _passwordFocusNode;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 28.0,
                width: 28.0,
              )
              ,Container(padding: EdgeInsets.only(top: 24.0),
                  child: Text("Welcome User, \n Login to Your account",style: Constants.boldHeading,textAlign: TextAlign.center,)),
              SizedBox(
                height: 60.0,
                width: 60.0,
              )
              ,Column(
                  children: <Widget>[
                    CustomInput(hintText: "Email....",
                      onChanged: (value){
                        _loginEmail=value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },),
                    CustomInput(hintText: "Password....",
                      onChanged: (value){
                        _loginPassword=value;
                      },
                      focusNode: _passwordFocusNode,
                      isPassword: true,
                      onSubmitted:(value){
                        _submitForm();
                      },),
                    CustomBtn(
                      btnStr: "Login",
                      onPressed: (){
                        _submitForm();
                      },
                      outlineBtn: false,
                      isLoading: _loginFormLoading,
                    ),
                    CustomBtn(
                      btnStr:"Countinue With Google",
                      outlineBtn: false,
                      onPressed: (){
                        signInWithGoogle();
                      },
                    )
                  ],
                ),
              SizedBox(
                height: 130.0,
                width: 120.0,
              )
              ,

              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0
                ),
                child: CustomBtn(btnStr: "Create New Account",onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RegisterPage()
                  ));
                },outlineBtn: true,),
              )
            ],
          ),
        ),
      )
    );
  }
}
