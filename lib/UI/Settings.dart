import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Theme', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    Get.changeTheme(ThemeData(
                        scaffoldBackgroundColor: Colors.green
                    ));
                  }, child: Text('Change Theme'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
