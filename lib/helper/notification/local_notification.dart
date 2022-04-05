import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

// for using sound in notification create sound.mp3 and sound.aiff.
// sound.mp3: under android/app/src/main/res/raw folder
// sound.aiff: under ios folder



class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    // required this.data
  });

  final int id;
  final String title;
  final String body;
  final String payload;
// final String data;
}

 class LocalNotificationService {
  static  String payDate = "";
  static bool open = false;
  static const String appName = "moviereminder";
  static const String appId = "moviereminder";
  static const String appDescription = "moviereminder notification channel";
  // using stream to listen to changes
  static final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  static final BehaviorSubject<String> selectNotificationSubject =  BehaviorSubject<String>();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =   AndroidInitializationSettings('ic_stat_ic_notification');
  static final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id,
          title: title??"",
          body: body??"",
          payload: payload??"")
      );
      }
  );
  static const MacOSInitializationSettings initializationSettingsMacOS =  MacOSInitializationSettings();
  static final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);

  static void init() {
    requestPermissions();
    selectNotification();
  }

  static void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

   static void selectNotification() async{
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          selectNotificationSubject.add(payload!);
        });
     selectNotificationSubject.stream.listen((String payload) async {
             //to write
     });

  }

   static void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) {
          showNotification(receivedNotification);
    });
  }

  static void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
     
      //to write
    });
  }

  static void showNotification(ReceivedNotification receivedNotification) {
    open = true;
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(appId, appName,
        channelDescription: appDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        priority: Priority.high,
        color: Color(0xFFFEB800),
        sound: RawResourceAndroidNotificationSound('sound'),
        ticker: 'ticker');
    const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: 'sound.aiff');
    const MacOSNotificationDetails macOSPlatformChannelSpecifics = MacOSNotificationDetails(sound: 'sound.aiff');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        receivedNotification.id, receivedNotification.title, receivedNotification.body, platformChannelSpecifics);
  }
}