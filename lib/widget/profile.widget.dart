import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/helper/storage/storage.controller.dart';
import 'package:moviereminder/helper/storage/storage.dart';
import 'package:ndialog/ndialog.dart';

import '../helper/colors.dart';
import '../helper/toast.dart';
import '../network/api_builder.dart';
import '../network/methods/post.dart';
import '../network/middleware/formData.middleware.dart';
import 'glassmorphism.dart';

class Profile extends StatefulWidget{
  const Profile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile>{
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    nameController.text = StorageService.get('name', StorageType.stringType);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 400,
      width: width,
      decoration: BoxDecoration(
          color: blurBackground,
          borderRadius: const BorderRadius.only(topLeft:Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: primaryColor)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
        child:  Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(alignment: Alignment.center, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(
                    "Profile", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(
                    "Your name:", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(
                    "Your old password (optional):", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
                              controller: oldPasswordController,
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
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(
                    "Your new password (optional):", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
                              controller: newPasswordController,
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
                    child: Text('Update', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18)),),
                    onPressed: ()  async{
                      if(nameController.text.isNotEmpty) {
                        Response? response = await ApiBuilder()
                            .setRoute('/user')
                            .setMethod(PostMethod())
                            .addBody('Name', nameController.text.toString())
                            .addBody('NewPassword', newPasswordController.text.toString())
                            .addBody('PrePassword', oldPasswordController.text.toString())
                            .addHeader('Authorization', StorageController.getAccessToken())
                            .addMiddleware(FormDataMiddleware())
                            .call();
                        if(response?.statusCode == 200) {
                          StorageService.set('name', nameController.text, StorageType.stringType);
                          Toast.success(response?.data['message']);
                          Navigator.pop(context);
                        }
                      } else {
                        Toast.error('Please fill your name');
                      }
                    },
                  ),)
                ],
              ),
            ),
            Positioned(child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.red, size: 28,),
              onPressed: () async {
                var result = await NDialog(
                  dialogStyle: DialogStyle(titleDivider: true, backgroundColor: Colors.white),
                  title: Text("Log out", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor)),),
                  content: Text("Are you sure you want to log out?", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.black54)),),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),),
                      onPressed: () async {
                        StorageController.removeAccessToken();
                        StorageService.delete('name');
                        StorageService.delete('fcm');
                        Navigator.pop(context, true);
                      },
                    ),
                    TextButton(
                      child: Text("No", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ).show(
                  context,
                );
                if(result) {
                  Navigator.pop(context);
                }
              },
            ), top: 0, right: 6,)
          ],
        ),
      ),
    );
  }
}