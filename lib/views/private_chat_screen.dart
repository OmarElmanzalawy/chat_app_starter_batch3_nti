import 'package:chat_app_starter/constants/app_colors.dart';
import 'package:chat_app_starter/models/message_model.dart';
import 'package:chat_app_starter/models/user_model.dart';
import 'package:chat_app_starter/services/chat_service.dart';
import 'package:chat_app_starter/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivateChatScreen extends StatelessWidget {
  PrivateChatScreen({super.key,required this.chatId,required this.userModel});

  final TextEditingController messageController = TextEditingController();
  final String chatId;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColors.chatBackground, 
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.appBarBackground, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: Text(userModel.username[0].toUpperCase())
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    userModel.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.white,))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: 5,
                  itemBuilder:(context, index) {
                    return ChatBubble(
                    );
                  },
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: AppColors.appBarBackground,
                    decoration: InputDecoration(
                      hintText: "Enter message",
                      enabledBorder: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade300,), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey.shade500,), 
                      ),
                      prefixIcon:   IconButton(
                        onPressed: (){},
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey.shade600,
                          ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.grey.shade600,
                          ),
                        )
                        ],
                      )
                    ),

                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF075E54), // WhatsApp green
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final message = MessageModel(
                        id: UniqueKey().toString(),
                        message: messageController.text,
                        senderId: FirebaseAuth.instance.currentUser!.uid,
                        senderName: userModel.username,
                        timeStamp: DateTime.now());
                    await ChatService.sendMessage(message, chatId);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}