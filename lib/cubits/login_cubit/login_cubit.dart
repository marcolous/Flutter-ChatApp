import 'package:bloc/bloc.dart';
import 'package:chat_app/helper/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emit(LoginFailure(errMessage: e.code));
        //showSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure(errMessage: e.code));
        //showSnackBar(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      emit(LoginFailure(errMessage: e.toString()));
    }
  }
}


// try {
//   await login();
//   showSnackBar(context, 'Success');
//   Navigator.push(
//     context,
//     CupertinoPageRoute(
//         builder: (context) => ChatPage(email: email)),
//   );
