import 'package:flutter/material.dart';
import 'authentication.dart';
import 'models/dialoguebox.dart';
import './widgets/createInput.dart';

class LoginRegisterPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  LoginRegisterPage({this.auth, this.onSignedIn});
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

// enum to distinguish between login and register page
enum FormType {
  login,
  register,
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  // instantiate object of DialogueBox
  DialogueBox dialogueBox = DialogueBox();

  // form input holder
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final formkey = GlobalKey<FormState>();
  FormType _formType = FormType.login;

// methods
  bool validateandsave() {
    final form = formkey.currentState;

    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  void validateandsubmit() async {
    if (validateandsave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(
              _emailController.text.toString(),
              _passwordcontroller.text.toString());

          print('login userid = ' + userId);
        } else {
          String userId = await widget.auth.SignUp(
              _emailController.text.toString(),
              _passwordcontroller.text.toString());
          print('Register userid = ' + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogueBox.information(context, 'Error:', e.toString());
        print('Error = ' + e.toString());
      }
    }
  }

  void movetoregister() {
    formkey.currentState.reset();

    setState(() {
      _formType = FormType.register;
    });
  }

  void movetologin() {
    formkey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blog Now'),
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(15.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CreateInput(_emailController, _passwordcontroller, logo),
                    if (_formType == FormType.login)
                      createbuttons('Login', movetoregister,
                          'Not have an account? Create Account!'),
                    if (_formType == FormType.register)
                      createbuttons('Create Account', movetologin,
                          'Already have an account? Login'),
                  ],
                ),
              )),
        ));
  }

  Widget createbuttons(state, redirectTo, msg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
            child: Text(
              state,
              style: TextStyle(fontSize: 20.0),
            ),
            textColor: Colors.white,
            color: Theme.of(context).buttonColor,
            onPressed: validateandsubmit),
        FlatButton(
            child: Text(
              msg,
              style: TextStyle(fontSize: 14.0),
            ),
            textColor: Theme.of(context).accentColor,
            onPressed: redirectTo),
      ],
    );
  }

  Widget logo() {
    return Hero(
        tag: 'hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 110.0,
          child: Image.asset('assets/images/logo.png'),
        ));
  }
}
