import 'dart:ui';

import 'package:chat_app_starter/models/message_model.dart';
import 'package:chat_app_starter/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key,required this.model,required this.chatId});

  final MessageModel model;
  final String chatId;

  @override
  Widget build(BuildContext context) {
     final bool isMe = FirebaseAuth.instance.currentUser!.uid == model.senderId;
    
    return GestureDetector(
      onLongPress: isMe ? () {
        showDialog(
          context: context,
          builder:(context) {
            return AlertDialog(
              title: Text("Delete Message"),
              content: Text("Are you sure you want to delete this message"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancel")),
                TextButton(onPressed: ()async{
                  await ChatService.deleteMessege(chatId, model.id, context);
                  Navigator.pop(context);
                }, child: Text("Delete"))
              ],
            );
          },
          );
      } : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe 
                        ? const Color(0xFFDCF8C6) 
                        : Colors.white, 
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
                        bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "message",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF075E54),
                              ),
                            ),
                          ),
                        Text(
                          model.message,
                          style: TextStyle(
                            color: isMe ? Colors.black87 : Colors.black87,
                            fontSize: 16,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              timeago.format(model.timeStamp),
                              style: TextStyle(
                                color: isMe ? Colors.black54 : Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 4),
                            if (!isMe) 
                              
                              Icon(
                                Icons.done_all,
                                size: 14,
                                color: Colors.blue.shade400, 
                              ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}