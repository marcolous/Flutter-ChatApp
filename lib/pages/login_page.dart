// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors_in_immutables, use_build_context_synchronously, must_be_immutable
import 'dart:developer';
import 'package:chat_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:chat_app/constants/constant.dart';
import 'package:chat_app/cubits/chat/chat_cubit.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/windgets/text_form_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  bool isLoading = false;
  String? email, password;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ChatPage(email: email)),
          );
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnackBar(context, state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
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
                        isLoading = true;

                        if (formKey.currentState!.validate()) {
                          // BlocProvider.of<AuthBloc>(context)
                          //     .login(email: email!, password: password!);

                          BlocProvider.of<AuthBloc>(context).add(
                              LoginEvent(email: email!, password: password!));
                        }
                        isLoading = false;
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
      ),
    );
  }

  Future<void> login() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
