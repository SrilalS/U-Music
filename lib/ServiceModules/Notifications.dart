import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await notifications.initialize(initializationSettings,
      onSelectNotification: (dt) {
    var data;
    data = data;
    return data;
  });
}

void shownotification(title, playbackinfo) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Main', 'Main Channel', 'Main Notifications Channel',
      importance: Importance.Default, 
      priority: Priority.Default, 
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      playSound: false,
      enableVibration: false,
      
      visibility: NotificationVisibility.Public,
      progress: (progress*100).round(),
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await notifications.show(
      0, title.toString(), playbackinfo.toString(), platformChannelSpecifics,
      payload: 'U Music');
}
