import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Home.dart';

class PermissionsReq extends StatefulWidget {
  @override
  _PermissionsReqState createState() => _PermissionsReqState();
}

class _PermissionsReqState extends State<PermissionsReq> {

  bool permitted = false;

  void getPermissions() async{
    bool status = await audioQuery.permissionsStatus();
    if(status){
      Get.offAll(()=>Home());
    } else {
      if (await Permission.storage.request().isGranted) {
      //await audioQuery.permissionsRequest().then((value) => print(value));
      Get.offAll(Home());
    } else {
      Get.snackbar('Error', 'Permission Denied');
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Icon(Icons.storage, size: 180, color: mainColor()),
            Container(
              width: Get.width/2,
              child: Text('We need Storage Access to read Your Music Library',
              textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: Get.width/2.5,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor()
                ),
                onPressed: (){
                  getPermissions();
                },
                child: Text('Grant', style: TextStyle(fontSize: 18),),
              ),
            )
          ],
        ),
      )
    );
  }
}
