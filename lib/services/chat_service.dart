import 'package:chat_app_starter/models/user_model.dart';
import 'package:chat_app_starter/view_model/app_brain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {

  static void fetchUsers()async{
    final snapshot = await FirebaseFirestore.instance.collection("users").get();
    final users = snapshot.docs.map((document) => UserModel.fromMap(document.data())).toList();

    appBrain.users.value = users;
  }

}