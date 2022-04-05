import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/model/reminder.mode.dart';
import 'package:moviereminder/network/methods/get.dart';
import 'package:moviereminder/widget/reminder.list.item.widget.dart';
import '../global/global.dart';
import '../helper/colors.dart';
import '../helper/storage/storage.controller.dart';
import '../network/api_builder.dart';
import '../widget/loading.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReminderListState();
  }
}

class ReminderListState extends State<ReminderListScreen> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  bool isLoadMoreReminders = false;
  List<ReminderModel> reminders = [];

  getMyReminderList() async {
    Response? response = await ApiBuilder()
        .setRoute('/reminder')
        .setMethod(GetMethod())
        .addHeader('Authorization', StorageController.getAccessToken())
        .call();
    if (response?.statusCode == 200) {
      response?.data["data"]["list"]
          .forEach((item) => {reminders.add(ReminderModel.fromJson(item))});
      if (mounted) {
        isLoadMoreReminders = false;
        isLoading = false;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    if (mounted) {
      GlobalState.onChangeWatchList.listen((event) {
        if (event == true) {
          reminders.clear();
          setState(() {
            isLoading = true;
          });
          getMyReminderList();
        }
      });
    }
    getMyReminderList();
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: backgroundMainColor,
            body: Loading(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 52, bottom: 16),
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                          'My Reminder List',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(child: ListView.builder(
                        controller: scrollController,
                        itemCount: reminders.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, right: 16, left: 16),
                            child: ReminderItem(reminder: reminders[index]),
                          );
                        },
                      )),
                    ],
                  ),
                  Container(
                    width: width,
                    height: 48,
                    color: blurBackground,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Back to home",
                              style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isLoading: isLoading,
            )));
  }
}
