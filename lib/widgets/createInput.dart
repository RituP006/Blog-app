import 'package:flutter/material.dart';

class CreateInput extends StatelessWidget {
  // form input holder
  final TextEditingController emailController;
  final TextEditingController passwordcontroller;

  final Function logo;
  CreateInput(this.emailController, this.passwordcontroller, this.logo);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        logo(),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
          ),
          validator: (value) {
            return value.isEmpty ? 'Email is required' : null;
          },
          controller: emailController,
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true, // to hide input
          validator: (value) {
            return value.isEmpty ? 'Password is required' : null;
          },
          controller: passwordcontroller,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
