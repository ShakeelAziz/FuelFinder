import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_finder_app/widgets/commonWidget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);
  @override
  _SettingScreenState createState() => _SettingScreenState();
}
class _SettingScreenState extends State<SettingScreen> {
  bool _value = false;
  int val = -1;
  int vlue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text("Settings", style: TextStyle(
          color: Colors.black,
        ),),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    buildText(
                      text: "General(PRO only",
                      color: Colors.red,
                      fontSize: 35.sp,
                    ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                            const Icon(Icons.send),
                            buildText(
                              text: "  Unlock PRO features",
                              color: Colors.black,
                              fontSize: 35.sp,
                            ),
                            ],
                          ),

                          buildText(
                            text: "No ads . Search via map. Options, e.g. to increase\n"
                                "the number of result. Improved results by the use\n"
                                "of additional data sources",
                            fontSize: 30.sp,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  buildText(
                    text: "Maximum number of results",
                    color: Colors.grey.shade400
                  ),
                  buildText(
                      text: "20",
                      color: Colors.grey.shade400
                  ),
                  SizedBox(height: 50.h,),
                  const CheckboxListTile(
                    title: Text('Display position accuracy'),
                    subtitle: Text('Display accuracy position in the title bar'),
                    autofocus: false,
                    activeColor: Colors.green,
                    checkColor: Colors.grey,
                    value: false,
                    onChanged: null
                  ),
                  SizedBox(height: 50.h,),
                  buildText(
                      text: "Unit of length",
                      color: Colors.grey.shade400
                  ),
                  buildText(
                      text: "Default",
                      color: Colors.grey.shade400
                  ),
                  SizedBox(height: 20.h,),

                  Divider(
                    thickness: 2.w,
                  ),
                  SizedBox(height: 20.h,),
                  buildText(
                    text: "Visual",
                    color: Colors.red,
                    fontSize: 35.sp,
                  ),
                  SizedBox(height: 20.h,),
                  CheckboxListTile(
                      title: const Text('Use generic icons'),
                      subtitle: const Text('Use colored one letter icons in the list view and map view'),
                      autofocus: false,
                      activeColor: Colors.red,
                      checkColor: Colors.white,
                      value: _value,
                      onChanged: (bool value) {
                        setState(() {
                          _value = value;
                        });
                      }
                  ),
                  ListTile(
                    onTap: (){
                      showDialog(context: context,
                          builder: (context){
                          return AlertDialog(
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(
                                    text: "Theme",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                RadioListTile(
                                  value: 1,
                                  activeColor: Colors.red,
                                  groupValue: val,
                                  onChanged: (int value) {
                                    setState(() {
                                      val = value;
                                    });
                                  },
                                  title: const Text("System Default"),
                                ),
                                  RadioListTile(
                                    value: 2,
                                    activeColor: Colors.red,
                                    groupValue: val,
                                    onChanged: (int value) {
                                      setState(() {
                                        val = value;
                                      });
                                    },
                                    title: const Text("Light"),
                                  ),
                                  RadioListTile(
                                    value: 3,
                                    activeColor: Colors.red,
                                    groupValue: val,
                                    onChanged: (int value) {
                                      setState(() {
                                        val = value;
                                      });
                                    },
                                    title: const Text("Dark"),
                                  ),

                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: buildText(
                                  text: "Cancel",
                                  color: Colors.red,
                                ),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                      });
                    },
                    title: buildText(
                      text: "Theme",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Light",
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      showDialog(context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(
                                      text: "Theme",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    RadioListTile(
                                      value: 4,
                                      activeColor: Colors.red,
                                      groupValue: vlue,
                                      onChanged: (int value) {
                                        setState(() {
                                          vlue = value;
                                        });
                                      },
                                      title: const Text("Default (like theme)"),
                                    ),
                                    RadioListTile(
                                      value: 5,
                                      activeColor: Colors.red,
                                      groupValue: val,
                                      onChanged: (int value) {
                                        setState(() {
                                          val = value;
                                        });
                                      },
                                      title: const Text("Light"),
                                    ),
                                    RadioListTile(
                                      value: 6,
                                      activeColor: Colors.red,
                                      groupValue: val,
                                      onChanged: (int value) {
                                        setState(() {
                                          val = value;
                                        });
                                      },
                                      title: const Text("Dark"),
                                    ),
                                    RadioListTile(
                                      value: 7,
                                      activeColor: Colors.red,
                                      groupValue: val,
                                      onChanged: (int value) {
                                        setState(() {
                                          val = value;
                                        });
                                      },
                                      title: const Text("Silver"),
                                    ),
                                    RadioListTile(
                                      value: 8,
                                      activeColor: Colors.red,
                                      groupValue: val,
                                      onChanged: (int value) {
                                        setState(() {
                                          val = value;
                                        });
                                      },
                                      title: const Text("Retro"),
                                    ),


                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: buildText(
                                    text: "Cancel",
                                    color: Colors.red,
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    title: buildText(
                      text: "Map style",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Default (like theme)",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h,),

                  Divider(
                    thickness: 2.w,
                  ),
                  SizedBox(height: 20.h,),
                  buildText(
                    text: "Change Log",
                    color: Colors.red,
                    fontSize: 35.sp,
                  ),
                  SizedBox(height: 20.h,),
                  CheckboxListTile(
                      title: const Text('Show change log for new versions'),
                      subtitle: const Text('show change log on first start after app updates'),
                      autofocus: false,
                      activeColor: Colors.red,
                      checkColor: Colors.white,
                      value:true,
                      onChanged: (bool value) {
                        setState(() {
                          _value = value;
                        });
                      }
                  ),
                  ListTile(
                    onTap: (){
                      showDialog(context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(
                                      text: "Change Log",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: buildText(
                                    text: "Cancel",
                                    color: Colors.red,
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    title: buildText(
                      text: "Change Log",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Show change log for this app",
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 2.w,
                  ),
                  /*SizedBox(height: 20.h,),
                  buildText(
                    text: "More POSITIVE INFINITY",
                    color: Colors.red,
                    fontSize: 35.sp,
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "HomePage",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "POSITIVE INFINITY on the web",
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Google Play",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "More apps by POSITIVE on Google Play",
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Facebook",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "POSITIVE INFINITY on Facebook",
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 2.w,
                  ),*/

                  SizedBox(height: 20.h,),
                  buildText(
                    text: "About",
                    color: Colors.red,
                    fontSize: 35.sp,
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "App version",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "1.0 basic",
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Feedback",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Questions? Improvement suggestions? Incorrect"
                          "translation? Feature requests? We'd love to hear "
                          "your feedback",
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Rate",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Please rate the app on Google Play if you like it."
                          "Thanks",
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Privacy Policy",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Send application to log developer",
                      color: Colors.black,
                    ),
                  ),
                  Divider(
                    thickness: 2.w,
                  ),

                  SizedBox(height: 20.h,),
                  buildText(
                    text: "Licenses",
                    color: Colors.red,
                    fontSize: 35.sp,
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Google Maps Places API",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Cotains information from Google Maps (http://www.maps.google.com/)",
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    onTap: (){
                    },
                    title: buildText(
                      text: "Global Petrol Prices",
                      color: Colors.black,
                    ),
                    subtitle: buildText(
                      text: "Petrol and Diesel prices provided by globalpetrolprices (https://www.globalpetrolprices.com/)"
                          " under the Creative Commons license CC BY 4.0 (https://creativecommons.org/license/by/4.0",
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
