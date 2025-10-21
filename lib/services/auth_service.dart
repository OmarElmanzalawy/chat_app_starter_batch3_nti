import 'package:firebase_auth/firebase_auth.dart';

class AuthService {


  static Future<bool> checkVerificationStatus()async{

    FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;

  }

  static Future<void> register(String email,String password,String userName)async{

    try{

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
         password: password);

      await credential.user!.updateDisplayName(userName);

      await credential.user!.sendEmailVerification();


    }catch(e){

    }

  }

}