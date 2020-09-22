import 'package:electronic_app/screens/home_page.dart';
import 'package:electronic_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<FirebaseApp> _app = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _app,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            ),
          );
        }
        if(snapshot.connectionState== ConnectionState.done)
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,streamsnapshot){
            if (streamsnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    "Error: ${streamsnapshot.error}",
                  ),
                ),
              );
            }
            if(streamsnapshot.connectionState == ConnectionState.active){
              User _user = streamsnapshot.data;
              if(_user== null){
                return LoginPage();
              } else{
                return HomePage();
              }
            }


            return Scaffold(
              body: Center(
                child: Text(
                    "Checking authentication"
                ),
              ),
            );
          },
        );

        return Scaffold(
              body: Center(
                child: Text(
                    "Initializing App.."
                ),
              ),
            );
      },
    );
  }
}
