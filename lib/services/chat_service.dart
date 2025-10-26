import 'package:chat_app_starter/models/user_model.dart';
import 'package:chat_app_starter/view_model/app_brain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {

  static void fetchUsers()async{
    print(FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await FirebaseFirestore.instance.collection("users").get();
    final users = snapshot.docs
    .where((document) => FirebaseAuth.instance.currentUser!.uid != document.data()["id"])
    .map((document) => UserModel.fromMap(document.data())).toList();

    appBrain.users.value = users;
  }

}