import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>(
      (event, emit) async {
        if (event is LoginEvent) {
          emit(LoginLoading());
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: event.email, password: event.password);
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
        } else if (event is RegisterEvent) {
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: event.email, password: event.password);
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
      },
    );
  }
}
