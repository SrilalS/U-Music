import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/UI/PermissionReq.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'UI/Home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter());
  await hEngine.init();
  var status = await Permission.storage.status;
  if (status.isGranted){
    isGranted = true;
  }
  runApp(UMusic());
}

bool isGranted = false;

class UMusic extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U Music',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff260f42),
        brightness: Brightness.dark,
        cardColor: Color(0xff381e58),
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xff260f42),
        )
      ),
      home: isGranted ? Home(): PermissionsReq(),
    );
  }
}
