import 'package:flutter/material.dart';
import 'loginRegister.dart';
import 'authentication.dart';
import 'homepage.dart';

class MappingPage extends StatefulWidget {
  final AuthImplementation auth;

  MappingPage(this.auth);

  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

// it will check the authstatus of user, if user exist then allow signin otherwise prevents user to access the app
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStatus = firebaseUserId == null
            ? AuthStatus.notSignedIn
            : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginRegisterPage(auth: widget.auth, onSignedIn: _signedIn);

      case AuthStatus.signedIn:
        return HomePage(auth: widget.auth, onSignedOut: _signedOut);
    }
    return null;
  }
}
