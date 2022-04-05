import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviereminder/model/reminder.mode.dart';
import 'package:moviereminder/network/methods/delete.dart';
import 'package:moviereminder/widget/glassmorphism.dart';
import 'package:moviereminder/widget/reminder.widget.dart';
import 'package:ndialog/ndialog.dart';
import '../global/global.dart';
import '../helper/colors.dart';
import '../helper/storage/storage.controller.dart';
import '../helper/toast.dart';
import '../network/api_builder.dart';

class ReminderItem extends StatefulWidget {
  final ReminderModel reminder;

  const ReminderItem({Key? key, required this.reminder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReminderItemState();
  }
}

class ReminderItemState extends State<ReminderItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Glassmorphism(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.reminder.movie.bigImage,
                  fit: BoxFit.cover,
                  width: width,
                  height: 175,
                  placeholder: (buildContext, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Positioned(
                  child: Glassmorphism(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/imdb.png',
                              width: 35,
                            ),
                            Text(widget.reminder.movie.imdbScore,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 14,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = primaryColor,
                                )))
                          ],
                        ),
                      ),
                      borderRadius: 8,
                      width: 70,
                      border: 1,
                      height: 24),
                  top: 4,
                  right: 4,
                ),
                Positioned(
                  child: Glassmorphism(
                      child: SizedBox(
                        height: 35,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: width - 36,
                              child: Text(widget.reminder.movie.title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          fontSize: 14, color: Colors.white))),
                            )
                          ],
                        ),
                      ),
                      borderRadius: 0,
                      border: 0,
                      width: width - 20,
                      height: 35),
                  bottom: 0,
                ),
                Positioned(child: InkWell(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: const Icon(Icons.delete_forever, color: Colors.white,),
                  ),
                  enableFeedback: true,
                  onTap: () async {
                    NDialog(
                      dialogStyle: DialogStyle(titleDivider: true, backgroundColor: Colors.white),
                      title: Text("Delete Reminder", style: GoogleFonts.openSans(textStyle: const TextStyle(color: primaryColor)),),
                      content: Text("Are you sure you want to delete this reminder?", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.black54)),),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Yes", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),),
                          onPressed: () async {
                            Response? response = await ApiBuilder()
                                .setRoute('/reminder/'+ widget.reminder.id.toString())
                                .setMethod(DeleteMethod())
                                .addHeader('Authorization', StorageController.getAccessToken())
                                .call();
                            if(response?.statusCode == 200) {
                              Toast.success(response?.data['message']);
                              GlobalState.changeWatchList(true);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        TextButton(
                          child: Text("No", style: GoogleFonts.openSans(textStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ).show(
                      context,
                    );
                  },
                ), top: 8, left: 8,),
                Positioned(child: InkWell(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: const Icon(Icons.edit, color: Colors.white,),
                  ),
                  enableFeedback: true,
                  onTap: () async {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: ReminderWidget(isEdit: true, movie: widget.reminder.movie, reminder: widget.reminder),
                        );
                      },
                    );

                  },
                ), top: 8, left: 54,)
              ],
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reminder title: ',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 0), child: Text(widget.reminder.title, textAlign: TextAlign.justify,style: GoogleFonts.openSans(
                          textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reminder description: ',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 0), child: Text(widget.reminder.description, textAlign: TextAlign.justify,style: GoogleFonts.openSans(
                          textStyle: const TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold),),),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          'Reminder start date:',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Padding(padding:  const EdgeInsets.only(left: 4), child: Text(widget.reminder.date, overflow: TextOverflow.ellipsis, style: GoogleFonts.openSans(
                            textStyle: const TextStyle(color: primaryColor, fontSize: 16))),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          'Reminder interval:',
                          style: GoogleFonts.openSans(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Padding(padding:  const EdgeInsets.only(left: 4), child: Text('each '+widget.reminder.interval + ' days',overflow: TextOverflow.ellipsis, style: GoogleFonts.openSans(
                            textStyle: const TextStyle(color: primaryColor, fontSize: 16))),),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        borderRadius: 12,
        width: width,
        height: 350,
        border: 1);
  }
}
