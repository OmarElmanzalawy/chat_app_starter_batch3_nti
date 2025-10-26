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

  static String createChatId(String receiverId){
    String chatId = "";
    final myId = FirebaseAuth.instance.currentUser!.uid;

    if(myId.compareTo(receiverId) < 0){
      chatId = "$myId$receiverId";
    }else{
      chatId = "$receiverId$myId";
      
    }
    return chatId;

  }

  static Future<bool> checkIfIdExists(String chatId)async{
    final document = await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    return document.exists;
  }

  static Future<void> createChat(String chatId)async{
    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({});
  }

}