import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Styles/Styles.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  void changeColor(int color) async{
    await hEngine.saveThemeColor(color);
    settingsChanged.value = settingsChanged.value++;
  }

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

                  Text('Theme',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xffe42c3f)
                      ),
                      onPressed: (){
                        changeColor(0xffe42c3f);
                      }, child: Text('Red')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff2051e5)
                      ),
                      onPressed: (){
                        changeColor(0xff2051e5);
                      }, child: Text('Blue')
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff9500ff)
                    ),
                      onPressed: (){
                        changeColor(0xff9500ff);
                      }, child: Text('Purple')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff000000)
                      ),
                      onPressed: (){
                        changeColor(0xff000000);
                      }, child: Text('Black')
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
