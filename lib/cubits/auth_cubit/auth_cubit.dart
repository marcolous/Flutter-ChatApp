import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());


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


  
  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: e.code));
        //showSnackBar(context, 'Weak Password!');
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: e.code));

        //showSnackBar(context, 'Email already exists!');
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: e.toString()));
    }
  }


}
