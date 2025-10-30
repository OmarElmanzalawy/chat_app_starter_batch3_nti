import 'package:chat_app_starter/constants/app_colors.dart';
import 'package:chat_app_starter/services/auth_service.dart';
import 'package:chat_app_starter/services/chat_service.dart';
import 'package:chat_app_starter/view_model/app_brain.dart';
import 'package:chat_app_starter/views/private_chat_screen.dart';
import 'package:chat_app_starter/views/sign_in_screen.dart';
import 'package:chat_app_starter/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    ChatService.fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: Colors.white),
        actionsPadding: EdgeInsets.all(12),
        actions: [
          Icon(Icons.search),
          IconButton(onPressed: ()async{
            await AuthService.logout();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => SignInScreen(),), (route) => false);
          }, icon: Icon(Icons.logout))
          // Icon(Icons.more_vert)
        ],
        toolbarHeight: 100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Whatsapp",style: TextStyle(color: Colors.white),),
            const SizedBox(height: 10,),
            ValueListenableBuilder(
              valueListenable: appBrain.users,
              builder:(context, value, child) =>  Text("${appBrain.users.value.length} users available",style: TextStyle(color: Colors.grey.shade300,fontSize: 14),))
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: appBrain.users,
        builder:(context, value, child) {
          return ListView.builder(
          itemCount: appBrain.users.value.length,
          itemBuilder:(context, index) {
            return GestureDetector(
              onTap: () async{
                // Navigator.push(context, MaterialPageRoute(builder:(context) => PrivateChatScreen(),));
                final receiverId = appBrain.users.value[index].id;
                final chatId = ChatService.createChatId(receiverId);
                print("chatId: $chatId");

                final doesExist = await ChatService.checkIfIdExists(chatId);

                if(doesExist){
                  print("Chat already existst");
                  Navigator.push(context, MaterialPageRoute(builder:(context) => PrivateChatScreen(chatId: chatId,userModel: appBrain.users.value[index],),));
                }else{
                  print("Creating chat for the first time");
                  await ChatService.createChat(chatId);
                  Navigator.push(context, MaterialPageRoute(builder:(context) => PrivateChatScreen(chatId: chatId,userModel: appBrain.users.value[index]),));
                }
              },
              child: UserCard(
                model: appBrain.users.value[index],
              ),
            );
          },
          );
        } 
      ),
    );
  }
}