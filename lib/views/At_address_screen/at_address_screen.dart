import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_finder_app/views/Near_by_screen/near_by_maps.dart';
import 'package:fuel_finder_app/widgets/commonwidget.dart';

import 'List_Places.dart';
import 'atAddressMap.dart';


class AtAddressScreen extends StatefulWidget {
  const AtAddressScreen({Key key}) : super(key: key);

  @override
  _AtAddressScreenState createState() => _AtAddressScreenState();
}

class _AtAddressScreenState extends State<AtAddressScreen> {
  List<Choice> choices = const <Choice>[
    Choice(title: 'Share', icon: Icons.arrow_right),
    Choice(title: 'Report missing entry', icon: Icons.exit_to_app),
  ];

  final TextEditingController nameController = TextEditingController();

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                text: "LIST",
              ),
              Tab(
                text: "MAP",
              ),
            ],
            indicatorColor: Colors.red,
            indicatorWeight: 2,
          ),
          title: buildTextField(
            controller: nameController,
            hintText: "Enter address..",
            textAlignVertical: TextAlignVertical.bottom
          ),
          actions: <Widget>[

            IconButton(onPressed: (){

            }, icon: const Icon(Icons.keyboard_voice_rounded)),
            PopupMenuButton<Choice>(
              color: Colors.white,
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            choice.title,
                            style: const TextStyle(color: Colors.black),
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            list_Places(),
            AtAddressMap(),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({ this.title,  this.icon});

  final String title;
  final IconData icon;
}
