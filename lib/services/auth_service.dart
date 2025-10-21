import 'package:chat_app_starter/views/email_verification_screen.dart';
import 'package:chat_app_starter/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

      // await credential.user!.sendEmailVerification();


    }catch(e){

    }

  }

  static Future<void> login(String email, String password,BuildContext context)async{

    try{

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if(credential.user!.emailVerified){
        Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen(),));
      }else{
        Navigator.push(context, MaterialPageRoute(builder:(context) => EmailVerificationScreen(),));
      }

    }catch(e){


    }

  }

}