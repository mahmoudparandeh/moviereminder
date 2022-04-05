import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviereminder/helper/storage/storage.dart';
import 'helper/colors.dart';
import 'helper/notification/local_notification.dart';
import 'helper/notification/notification.dart';
import 'screen/home.screen.dart';

Future<void> initService() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  const MethodChannel _channel = MethodChannel('licharstudio.com/moviereminder_channel');
  Map<String, String> channelMap = {
    "id": "moviereminder",
    "name": "moviereminder",
    "description": "moviereminder notifications",
  };
  await _channel.invokeMethod('createNotificationChannel', channelMap);
  await Firebase.initializeApp();
  await StorageService.getInstance();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationService.init();
  NotificationService.init();
  NotificationService.getFCMToken();
  NotificationService.subscribeFCM('all');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: primaryColor,
    statusBarIconBrightness: Brightness.light, //top bar icons
    systemNavigationBarColor: primaryColor, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  WidgetsFlutterBinding.ensureInitialized();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print("Handling a background message: ${message.messageId}");
}

void main() async{
  initService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StyledToast(locale: const Locale('en', 'US'),
    child: MaterialApp(
      title: 'Movie Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(child: HomeScreen()),
    ));
  }
}
