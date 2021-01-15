import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/UI/MainHome.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umusicv2/UI/PermissionReq.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData.dark(),
      home: isGranted ? MainHome(): PermissionsReq(),
    );
  }
}
