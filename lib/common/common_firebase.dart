import 'package:firebase_auth/firebase_auth.dart';

class CommonFirebase {

  Future<bool> createUser(String userEmail, String userPw) async {
    try {
      final curUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPw
      );
      if(curUser != null){
        return true;
      }else{
        return false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      print('여기를 타는지 확인');
      return false;
    }
  }
}