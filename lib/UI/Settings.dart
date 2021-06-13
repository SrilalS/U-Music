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


  void changeMainColor(int color) async{
    await hEngine.saveThemeColor(color);
    setState(() {
      settingsChanged.value = settingsChanged.value++;
    });
  }

  void changeBackColor(int color, int shade) async{
    await hEngine.saveBackColor(color);
    await hEngine.saveBackShadeColor(shade);
    setState(() {
      settingsChanged.value = settingsChanged.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor(),
      appBar: AppBar(
        backgroundColor: backColor(),
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //MainColor
              Row(
                children: [
                  Text('Theme Color',
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
                        changeMainColor(0xffe42c3f);
                      }, child: Text('Red')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff2051e5)
                      ),
                      onPressed: (){
                        changeMainColor(0xff2051e5);
                      }, child: Text('Blue')
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff9500ff)
                    ),
                      onPressed: (){
                        changeMainColor(0xff9500ff);
                      }, child: Text('Purple')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff989898)
                      ),
                      onPressed: (){
                        changeMainColor(0xff989898);
                      }, child: Text('Gray')
                  )
                ],
              ),

              //BackColor
              SizedBox(height: 32),
              Row(
                children: [
                  Text('Background Color',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.width*0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff420f10)
                        ),
                        onPressed: (){
                          changeBackColor(0xff420f10,0xff581e1f);
                        }, child: Text('Deep Red')
                    ),
                  ),
                  Container(
                    width: Get.width*0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff0f2142)
                        ),
                        onPressed: (){
                          changeBackColor(0xff0f2142,0xff1e3558);
                        }, child: Text('Deep Blue')
                    ),
                  ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.width*0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff260f42)
                        ),
                        onPressed: (){
                          changeBackColor(0xff260f42,0xff381e58);
                        }, child: Text('Deep Purple')
                    ),
                  ),
                  Container(
                    width: Get.width*0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff222222)
                        ),
                        onPressed: (){
                          changeBackColor(0xff222222,0xff565656);
                        }, child: Text('Deep Gray')
                    )
                  ),


                ],
              ),

              SizedBox(height: 32),
              Row(
                children: [
                  Text('FeedBack',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 8),
              Text('Because this app do not include any form of user tracking i can\'t get real feedback from the users. if you have any feedback i would love to hear it. please send your feedback to me on Twitter or use the Email below!',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              Row(
                children: [
                  Text('Twitter: @SrilalSS',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500),),
                ],
              ),

              SizedBox(height: 32),
              Row(
                children: [
                  Text('About',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 8),
              Text('An Ad-Free and Open-Source Music Player Made using Flutter. I Made this in my free time as a way to practice flutter. never thought this will ever get downloaded this many times or even get this much feedback. I Will make improvements continuously',
                style: TextStyle(
                    fontSize: 16,
                )),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Developer : Srilal S. Siriwardhane',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('GitHub : SrilalS9X@Gmail.com',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Contact : SrilalS9X@Gmail.com',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500),),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
