import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviereminder/global/global.dart';
import 'package:moviereminder/helper/storage/storage.controller.dart';

import '../helper/ads/ads.dart';
import '../helper/colors.dart';
import '../helper/toast.dart';
import '../model/movie.model.dart';
import '../model/reminder.mode.dart';
import '../network/api_builder.dart';
import '../network/methods/post.dart';
import '../network/methods/put.dart';
import '../network/middleware/formData.middleware.dart';
import 'glassmorphism.dart';

class ReminderWidget extends StatefulWidget{
  final bool isEdit;
  final MovieModel movie;
  final ReminderModel reminder;
  const ReminderWidget({Key? key, required this.isEdit, required this.movie, required this.reminder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReminderState();
  }
}

class ReminderState extends State<ReminderWidget>{
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String startDate = '';
  String startTime = '';
  TextEditingController daysController = TextEditingController();
  late DateTime dateTime;
  late TimeOfDay timeOfDay;
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;


  void initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {

            },
          );
          isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  @override
  void initState() {
    if(widget.isEdit) {
      titleController.text = widget.reminder.title;
      descriptionController.text = widget.reminder.description;
      daysController.text = widget.reminder.interval;
      startDate = widget.reminder.date.split(' ').first;
      List<String> dateData = startDate.split('-');
      dateTime = DateTime(int.parse(dateData[0]), int.parse(dateData[1]), int.parse(dateData[2]));
      startTime = widget.reminder.date.split(' ').last;
      List<String> timeData = startDate.split('-');
      timeOfDay = TimeOfDay(hour: int.parse(timeData[0]), minute: int.parse(timeData[1]));
    }
    initInterstitialAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: width,
      decoration: BoxDecoration(
          color: blurBackground,
          borderRadius: const BorderRadius.only(topLeft:Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: primaryColor)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 0, sigmaX: 0),
        child:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                widget.isEdit ? 'Edit Reminder' : 'Create Reminder', style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 18)),
              ),),
              Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                "Title:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
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
                          controller: titleController,
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
                "Description:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
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
                          controller: descriptionController,
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
              Row(
                children: [
                  Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                        "Reminder start date:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                        child: InkWell(
                          child: Glassmorphism(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 14, left: 16),
                                  width: width/2 - 77,
                                  child: Text(startDate, style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 18)),),
                                )
                              ],
                            ),
                            width: width/2 -33,
                            height: 48,
                            border: 1,
                            borderRadius: 10,
                          ),
                          onTap: () async {
                            dateTime = (await showDatePicker(locale: const Locale('en', 'uk'),firstDate: DateTime(1900), initialDate: DateTime.now(), lastDate: DateTime(3000), context: context))!;
                            startDate = dateTime.toString().split(' ').first;
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                        "Reminder start time:", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
                        child: InkWell(
                          child: Glassmorphism(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 14, left: 16),
                                  width: width/2 - 77,
                                  child: Text(startTime, style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 18)),),
                                )
                              ],
                            ),
                            width: width/2 -33,
                            height: 48,
                            border: 1,
                            borderRadius: 10,
                          ),
                          onTap: () async {
                            timeOfDay = (await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dial,
                            ))!;
                            startTime = (timeOfDay.hour.toString().length > 1 ? timeOfDay.hour.toString() : '0'+timeOfDay.hour.toString())+':'+(timeOfDay.minute.toString().length>1 ? timeOfDay.minute.toString() : '0'+timeOfDay.minute.toString());
                            setState(() {

                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(padding: const EdgeInsets.only(right:16 , left:16, top:8), child: Text(
                "Repeat every ... days?", style: GoogleFonts.lato(textStyle: const TextStyle(color: primaryColor, fontSize: 14)),
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
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: primaryColor),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(16.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                              BorderSide(color: primaryColor, width: 1.0),
                            ),),
                          controller: daysController,
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
                child: Text(widget.isEdit ? 'Edit Reminder' : 'Create Reminder', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18)),),
                onPressed: ()  async{
                  if(titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && daysController.text.isNotEmpty && startDate.isNotEmpty) {
                    String route = '';
                    widget.isEdit ? route = '/reminder/'+ widget.reminder.id.toString() : route = '/reminder';
                    DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute).toUtc();
                    Response? response = await ApiBuilder()
                        .setRoute(route)
                        .setMethod(widget.isEdit ? PutMethod() : PostMethod())
                        .addBody('MovieId', widget.movie.id.toString())
                        .addBody('StartDate',date.toString())
                        .addBody('Title', titleController.text.toString())
                        .addBody('Description', descriptionController.text.toString())
                        .addBody('Interval', daysController.text.toString())
                        .addHeader('Authorization', StorageController.getAccessToken())
                        .addMiddleware(FormDataMiddleware())
                        .call();
                    if(response?.statusCode == 200) {
                      Toast.success(response?.data['message']);
                      GlobalState.changeWatchList(true);
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        interstitialAd.show();
                      });
                    }
                  } else {
                    Toast.error('Please fill all inputs');
                  }
                },
              ),)
            ],
          ),
        ),
      ),
    );
  }
}