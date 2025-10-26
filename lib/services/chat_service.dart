import 'package:chat_app_starter/models/message_model.dart';
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

  static Stream<List<MessageModel>> fetchMessageStream(String chatId){
    final collectionStream =  FirebaseFirestore.instance.collection("chats").doc(chatId).collection("messages").orderBy("timeStamp").snapshots();

    return collectionStream.map(
      (snapshot) {
       return snapshot.docs.map((document) =>  MessageModel.fromJson(document.data())).toList();
      }
    );
    
    
  }


  static Future<bool> checkIfIdExists(String chatId)async{
    final document = await FirebaseFirestore.instance.collection("chats").doc(chatId).get();
    return document.exists;
  }

  static Future<void> createChat(String chatId)async{
    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({});
  }

  static Future<void> sendMessage(MessageModel message,String chatId)async{
    await FirebaseFirestore.instance.collection("chats").doc(chatId)
    .collection("messages").doc(message.id).set(message.toJson());
  }

}