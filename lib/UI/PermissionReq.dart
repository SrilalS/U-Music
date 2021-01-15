import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:umusicv2/UI/MainHome.dart';

class PermissionsReq extends StatefulWidget {
  @override
  _PermissionsReqState createState() => _PermissionsReqState();
}

class _PermissionsReqState extends State<PermissionsReq> {

  bool permitted = false;

  void getPermissions() async{
    if (await Permission.storage.request().isGranted) {
      Get.offAll(MainHome());
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

            Icon(Icons.storage, size: 128, color: Colors.blue),
            Container(
              width: Get.width/2,
              child: Text('We need Storage Access to read Your Music Library',
              textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: Get.width/3,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                onPressed: (){
                  getPermissions();
                },
                color: Colors.blue,
                child: Text('Grant'),
              ),
            )
          ],
        ),
      )
    );
  }
}
