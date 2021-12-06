import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class ListPersonPage extends StatefulWidget {
  ListPersonPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPersonPageState createState() => _ListPersonPageState();
}

class _ListPersonPageState extends State<ListPersonPage> {
  List<Person> _personList = [];
  List<Person> _filteredList = [];
  TextEditingController controller = new TextEditingController();
  String filter = "";

  Widget appBarTitle = new Text("List of People");
  Icon actionIcon = new Icon(Icons.search);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    PersonDataBuilder pdb = new PersonDataBuilder();
    List<Person> tmpList =  [];
    for(int i=0; i < pdb.getPeople().length; i++) {
      tmpList.add(pdb.getPeople()[i]);
    }
    setState(() {
      _personList = tmpList;
      _filteredList = _personList;
    });
    controller.addListener(() {
      if(controller.text.isEmpty) {
        setState(() {
          filter = "";
          _filteredList = _personList;
        });
      } else {
        setState(() {
          filter = controller.text;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final appTopAppBar = AppBar(
      elevation: 0.1,
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white),
                  ),
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  autofocus: true,
                  cursorColor: Colors.white,
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("List of People");
                _filteredList = _personList;
                controller.clear();
              }
            });
          },
        ),
      ],
    );

    ListTile personListTile(Person person) => ListTile(
      title: Text(
        person.personFirstName + " " + person.personLastName,
        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
      ),);

    Card personCard(Person person) => Card(
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: personListTile(person),
      ),
    );

    if((filter.isNotEmpty)) {
      List<Person> tmpList = [];
      for(int i = 0; i < _filteredList.length; i++) {
        if(_filteredList[i].personFirstName.toLowerCase().contains(filter.toLowerCase())) {
          tmpList.add(_filteredList[i]);
        }
      }
      _filteredList = tmpList;
    }

    final appBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _personList == null ? 0 : _filteredList.length,
        itemBuilder: (BuildContext context, int index) {
          return personCard(_filteredList[index]);
        },
      ),
    );

    return Scaffold(
      appBar: appTopAppBar,
      body: appBody,
    );
  }
}
class Person {
  String personFirstName;
  String personLastName;

  Person(
      {this.personFirstName, this.personLastName}
      );
}
class PersonDataBuilder {
  List getPeople() {
    return [
      Person(
          personFirstName: "John",
          personLastName: "Smith"
      ),
      Person(
          personFirstName: "Alex",
          personLastName: "Johnson"
      ),
      Person(
          personFirstName: "Jane",
          personLastName: "Doe"
      ),
      Person(
          personFirstName: "Eric",
          personLastName: "Johnson"
      ),
      Person(
          personFirstName: "Michael",
          personLastName: "Eastwood"
      ),
      Person(
          personFirstName: "Benjamin",
          personLastName: "Woods"
      ),
      Person(
          personFirstName: "Abraham",
          personLastName: "Atwood"
      ),
      Person(
          personFirstName: "Anna",
          personLastName: "Clack"
      ),
      Person(
          personFirstName: "Clark",
          personLastName: "Phonye"
      ),
      Person(
          personFirstName: "Kerry",
          personLastName: "Mirk"
      ),
      Person(
          personFirstName: "Eliza",
          personLastName: "Wu"
      ),
      Person(
          personFirstName: "Jackey",
          personLastName: "Lee"
      ),
      Person(
          personFirstName: "Kristin",
          personLastName: "Munson"
      ),
      Person(
          personFirstName: "Oliver",
          personLastName: "Watson"
      ),

    ];
  }
}