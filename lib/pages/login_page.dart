// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors_in_immutables, use_build_context_synchronously
import 'dart:developer';
import 'package:chat_app/constants/constant.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/windgets/text_form_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: kAppBarColor,
          middle: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/scholar.png'),
                  ),
                ),
                Center(
                  child: Text(
                    'Scholar Chat',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormFieldWidget(
                    onChange: (data) {
                      email = data;
                    },
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false),
                SizedBox(height: 20),
                TextFormFieldWidget(
                  onChange: (data) {
                    password = data;
                  },
                  label: 'Password',
                  autocorrect: false,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (formKey.currentState!.validate()) {
                        try {
                          await login();
                          showSnackBar(context, 'Success');
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ChatPage(email: email)), );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            showSnackBar(
                                context, 'No user found for that email.');
                          } else if (e.code == 'invalid-credential') {
                            showSnackBar(context,
                                'Wrong password provided for that user.');
                          }
                        }
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an Account? '),
                    RichText(
                      text: TextSpan(
                        text: 'Register',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            log('clicked');
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
