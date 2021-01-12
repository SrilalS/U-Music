import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings();
  await notifications.initialize(initializationSettings,
      onSelectNotification: (dt) {
    var data;
    data = data;
    return data;
  });
}

void removeNotifications(){
  notifications.cancelAll();
}

void shownotification(title, playbackinfo) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Main', 'Main Channel', 'Main Notifications Channel',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      playSound: false,
      enableVibration: false,
      timeoutAfter: 500,
      
      visibility: NotificationVisibility.public,
      progress: (progress*100).round(),
      ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails();
  await notifications.show(
      0, title.toString(), playbackinfo.toString(), platformChannelSpecifics,
      payload: 'U Music');
}
