import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fuel_finder_app/views/At_address_screen/at_address_screen.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by.dart';
import 'package:fuel_finder_app/views/Prices_list.dart';
import 'package:fuel_finder_app/views/Settings/setting_screen.dart';
import 'package:country_icons/country_icons.dart';

class DrawerSide extends StatefulWidget {
  const DrawerSide({Key key}) : super(key: key);

  @override
  _DrawerSideState createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  Widget lisTile({IconData icon, String title, GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 32,
      ),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color:Colors.white,image: DecorationImage(alignment:Alignment.centerRight,image: AssetImage("images/logo.jpg"))),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "FILL UP MZANSI",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5,),
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              image:
                                  DecorationImage(image: AssetImage("icons/flags/png/za.png",package: 'country_icons'))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "v1.0 Basic",
                      style: TextStyle(color: Colors.black, fontSize: 30.sp),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Text(
              "Search Gas Stations",
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NearByScreen()));
            },
            title: const Text(
              "Near By",
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.my_location_sharp,
              size: 25,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AtAddressScreen()));
              },
            title: const Text(
              "At Address",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.location_city,
              size: 25,
            ),
          ),
          Divider(
            thickness: 2.w,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Text(
              "About",
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            title: const Text(
              "Settings",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.settings,
              size: 25,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Prices_list()));
            },
            title: const Text(
              "World Gasoline Prices",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.local_gas_station,
              size: 25,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            title: const Text(
              "Recommended app",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.share,
              size: 25,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            title: const Text(
              "More apps",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.more,
              size: 25,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
            title: const Text(
              "FAQ",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.question_answer_outlined,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
