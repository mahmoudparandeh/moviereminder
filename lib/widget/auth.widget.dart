import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/storage/storage.controller.dart';
import 'package:moviereminder/helper/storage/storage.dart';
import 'package:moviereminder/network/api_builder.dart';
import 'package:moviereminder/network/methods/post.dart';

import '../helper/colors.dart';
import '../helper/notification/notification.dart';
import '../helper/toast.dart';
import '../network/middleware/formData.middleware.dart';
import 'glassmorphism.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AuthState();
  }
}

class AuthState extends State<AuthWidget> with SingleTickerProviderStateMixin{

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late TabController tabController;
  bool isForgetTapped = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 360,
      width: width,
      decoration: BoxDecoration(
          color: blurBackground,
          borderRadius: const BorderRadius.only(topLeft:Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: primaryColor)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
        child:  DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                controller: tabController,
                indicatorColor: primaryColor,
                tabs: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text("Sign In", style: GoogleFonts.petitFormalScript(textStyle: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold))),),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text("Sign Up", style: GoogleFonts.petitFormalScript(textStyle: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold))),),
                ],
              ),
              SizedBox(
                height: 310,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    SingleChildScrollView(
                      child: isForgetTapped ? Column (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: InkWell(
                              child: Text(
                                "Back to sign in", style: GoogleFonts.lato(textStyle: const TextStyle(color: Colors.white, fontSize: 18)),
                              ),
                              enableFeedback: true,
                              onTap: () {
                                isForgetTapped = false;
                                setState(() {

                                });
                              },
                            ),),
                            Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                              "Email:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                            ),),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                              child: Glassmorphism(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width - 34,
                                      child: TextField(
                                        maxLines: 1,
                                        keyboardType: TextInputType.emailAddress,
                                        style: const TextStyle(color: primaryColor),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(16.0),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: primaryColor, width: 1.0),
                                          ),),
                                        controller: emailController,
                                      ),
                                    )
                                  ],
                                ),
                                width: width,
                                height: 48,
                                border: 1,
                                borderRadius: 10,
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 16), child:
                            TextButton(
                              style: ButtonStyle(
                                shape:  MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                )),
                                fixedSize: MaterialStateProperty.all<Size>(Size(width, 48)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                              ),
                              child: Text('Reset Password', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18)),),
                              onPressed: ()  async{
                                if(emailController.text.isNotEmpty) {
                                  Response? response = await ApiBuilder()
                                      .setRoute('/auth/resetPassword')
                                      .setMethod(PostMethod())
                                      .addBody('Email', emailController.text.toString())
                                      .addMiddleware(FormDataMiddleware())
                                      .call();
                                  if(response?.statusCode == 200) {
                                    Toast.success(response?.data['message']);
                                    isForgetTapped = false;
                                    setState(() {

                                    });
                                  }
                                } else {
                                  Toast.error('Please fill email and password');
                                }
                              },
                            ),)
                          ]
                      ) : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                            "Email:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: Glassmorphism(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width - 34,
                                    child: TextField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: primaryColor),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(16.0),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: primaryColor, width: 1.0),
                                        ),),
                                      controller: emailController,
                                    ),
                                  )
                                ],
                              ),
                              width: width,
                              height: 48,
                              border: 1,
                              borderRadius: 10,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                            "Password:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: Glassmorphism(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width - 34,
                                    child: TextField(
                                      maxLines: 1,
                                      obscureText: true,
                                      style: const TextStyle(color: primaryColor),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(16.0),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: primaryColor, width: 1.0),
                                        ),),
                                      controller: passwordController,
                                    ),
                                  )
                                ],
                              ),
                              width: width,
                              height: 48,
                              border: 1,
                              borderRadius: 10,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: InkWell(
                            child: Text(
                              "Forget your password?", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                            ),
                            enableFeedback: true,
                            onTap: () {
                                isForgetTapped = true;
                                setState(() {

                                });
                            },
                          ),),
                          Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 16), child:
                          TextButton(
                            style: ButtonStyle(
                              shape:  MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              )),
                              fixedSize: MaterialStateProperty.all<Size>(Size(width, 48)),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                            ),
                            child: Text('Sign In', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18)),),
                            onPressed: ()  async{
                              if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                                Response? response = await ApiBuilder()
                                    .setRoute('/auth/signIn')
                                    .setMethod(PostMethod())
                                    .addBody('Password', passwordController.text.toString())
                                    .addBody('Email', emailController.text.toString())
                                    .addBody('FcmToken', NotificationService.FCMToken)
                                    .addMiddleware(FormDataMiddleware())
                                    .call();
                                if(response?.statusCode == 200) {
                                  StorageController.setAccessToken(response?.data['data']['token']['token']);
                                  StorageService.set('name', response?.data['data']['name'], StorageType.stringType);
                                  Toast.success('Login successfully');
                                  Navigator.pop(context);
                                }
                              } else {
                                Toast.error('Please fill email and password');
                              }
                            },
                          ),)
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                            "Name:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: Glassmorphism(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width - 34,
                                    child: TextField(
                                      maxLines: 1,
                                      style: const TextStyle(color: primaryColor),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(16.0),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: primaryColor, width: 1.0),
                                        ),),
                                      controller: nameController,
                                    ),
                                  )
                                ],
                              ),
                              width: width,
                              height: 48,
                              border: 1,
                              borderRadius: 10,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                            "Email:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                            child: Glassmorphism(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width - 34,
                                    child: TextField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(color: primaryColor),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(16.0),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: primaryColor, width: 1.0),
                                        ),),
                                      controller: emailController,
                                    ),
                                  )
                                ],
                              ),
                              width: width,
                              height: 48,
                              border: 1,
                              borderRadius: 10,
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(left: 16, right: 16, top: 16), child:
                          TextButton(
                            style: ButtonStyle(
                              shape:  MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              )),
                              fixedSize: MaterialStateProperty.all<Size>(Size(width, 48)),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                            ),
                            child: Text('Sign Up', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18)),),
                            onPressed: () async {
                              if(emailController.text.isNotEmpty && nameController.text.isNotEmpty) {
                                Response? response = await ApiBuilder()
                                    .setRoute('/auth/signUp')
                                    .setMethod(PostMethod())
                                    .addBody('Email', emailController.text.toString())
                                    .addBody('Name', nameController.text.toString())
                                    .addMiddleware(FormDataMiddleware())
                                    .call();
                                if(response?.statusCode == 200) {
                                  Toast.success('Please check your email for password');
                                }
                              } else {
                                Toast.error('Please fill email and name');
                              }
                            },
                          ),)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}