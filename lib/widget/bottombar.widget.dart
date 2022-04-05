import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:moviereminder/helper/colors.dart';
import 'package:moviereminder/helper/navigator.dart';
import 'package:moviereminder/helper/storage/storage.controller.dart';
import 'package:moviereminder/screen/reminder.list.screen.dart';
import 'package:moviereminder/screen/watch.list.screen.dart';
import 'package:moviereminder/widget/auth.widget.dart';
import 'package:moviereminder/widget/glassmorphism.dart';
import 'package:moviereminder/widget/profile.widget.dart';

import '../helper/toast.dart';

class BottomBarWidget extends StatefulWidget{
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomBarState();
  }
}

class BottomBarState extends State<BottomBarWidget>{
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(alignment: Alignment.center,padding: const EdgeInsets.symmetric(horizontal: 16), child: Glassmorphism(child: GNav(
        rippleColor: Colors.grey,
        selectedIndex: -1,// tab button ripple color when pressed
        hoverColor: Colors.grey, // tab button hover color
        haptic: true, // haptic feedback
        tabBorderRadius: 15,
        tabActiveBorder: Border.all(color: primaryColor, width: 1), // tab button border
        tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
        tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
        curve: Curves.easeOutExpo, // tab animation curves
        duration: const Duration(milliseconds: 900), // tab animation duration
        gap: 8, // the tab button gap between icon and text
        color: Colors.grey[800], // unselected icon color
        activeColor: primaryColor, // selected icon and text color
        iconSize: 28, // tab button icon size
        tabBackgroundColor: primaryColor.withOpacity(0.1), // selected tab background color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
        tabs: [
          GButton(
            icon: Icons.favorite,
            text: 'Watch List',
            onPressed: () {
              if(StorageController.isAuthenticate()) {
                Navigator.push(context, SlideBottomRoute(page: const WatchListScreen()));
              } else {
                Toast.error('Please login to use this feature');
              }
            },
          ),
          GButton(
            icon: Icons.add_alert,
            text: 'Reminder',
            onPressed: () {
              if(StorageController.isAuthenticate()) {
                Navigator.push(context, SlideBottomRoute(page: const ReminderListScreen()));
              } else {
                Toast.error('Please login to use this feature');
              }
            },
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
            onPressed: () {
              if(StorageController.isAuthenticate()) {
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
                      child: const Profile(),
                    );
                  },
                );
              } else {
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
                      child: const AuthWidget(),
                    );
                  },
                );
              }
            },
          )
        ]
    ), borderRadius: 12, width: width-32, height: 36, border: 1),);
  }
}