import 'package:chat_app_starter/constants/app_colors.dart';
import 'package:chat_app_starter/services/auth_service.dart';
import 'package:chat_app_starter/widgets/action_button.dart';
import 'package:chat_app_starter/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> fadeAnimation;
  late final Animation<Offset> slideAnimation;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1500));
    scaleAnimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(0.2, 0.8,curve: Curves.elasticOut)
      ));
    fadeAnimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(0, 0.5)));
    slideAnimation = Tween(begin: Offset(0, 0.3),end: Offset.zero).animate(CurvedAnimation(parent: animationController, curve: Interval(0.4, 1.0,curve: Curves.easeOutBack)));

    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
        child: Container(
          // color: Colors.red,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8
                      )
                    ]
                  ),
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios)),
                ),
              ),
              const SizedBox(height: 30,),
              ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.brightGreen.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 5,
                          offset: Offset(0, 10)
                        )
                    ],
                    gradient: LinearGradient(
                      colors: [AppColors.brightGreen,AppColors.endGradient],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                      )
                  ),
                  child: Icon(Icons.lock_reset_rounded,color: Colors.white,size: 70,),
                ),
              ),
              const SizedBox(height: 20,),
              FadeTransition(
                opacity: fadeAnimation,
                child: Text("Reset Password",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w600),
                )),
              const SizedBox(height: 20,),
              Text(
                "Enter your email address and we will send you a link to reset your password",
                style: TextStyle(color: Colors.grey.shade600,fontSize: 16,),
                textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30,),
              SlideTransition(
                position: slideAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                       BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          spreadRadius: 5,
                          
                        )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green.withOpacity(0.2)
                            ),
                            child: Icon(Icons.mail_outline,color: AppColors.brightGreen,),
                          ),
                          
                          Text("Recovery Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      CustomTextField(hintText: "Enter your email", labelText: "Email", controller: _emailController),
                      const SizedBox(height: 20,),
                      ActionButton(onPressed: ()async{
                        await AuthService.sendResetEmail(_emailController.text, context);
                      },
                      title: "Send Recovery Email",
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}