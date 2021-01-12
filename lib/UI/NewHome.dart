import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:umusicv2/ServiceModules/NewEngine.dart';
import 'package:umusicv2/Widgets/Controlls.dart';
import 'package:umusicv2/Widgets/NewListView.dart';

class NXHome extends StatefulWidget {
  @override
  _NXHomeState createState() => _NXHomeState();
}

class _NXHomeState extends State<NXHome> {
  


  @override
  void initState() {
    
    super.initState();
    getSongs().then((value) {
      setState(() {});
    });
    broadcast();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Get.theme.primaryColor,
        statusBarBrightness: Get.theme.brightness,
        systemNavigationBarColor: Get.theme.accentColor));
    return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(flex: 3, child: newMainMusicList()),
                Expanded(flex: 1, child: controlls()),
                //albumArt != null ? Expanded(flex: 1, child: Image.memory(albumArt)) : Container(),
              ],
            ),
          ),
    );
  }
}
