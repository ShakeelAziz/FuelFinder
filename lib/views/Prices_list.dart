import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuel_finder_app/models/Prices_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';


class Prices_list extends StatefulWidget {
  const Prices_list({Key key}) : super(key: key);

  @override
  _Prices_listState createState() => _Prices_listState();
}

class _Prices_listState extends State<Prices_list> {
  var lists;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prices according to countries"),
      ),
      body: FutureBuilder<List<GppElement>>(
        future: _getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return ListView.builder(itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(snapshot.data[index].gppCountry.value),trailing: Text(snapshot.data[index].gppGasoline.toString()+" "+snapshot.data[index].gppCurrency),);
                });
          }
        },
      ),
    );
  }

  Future<List<GppElement>> _getData() async {
    List<GppElement> list = [];
    final Xml2Json xml2Json = Xml2Json();
    var headers = {
      'Cookie': '20211127122222=1; 20211127122551=1; PHPSESSID=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d; my_session_id=2d5c7fc3943ef7b7ed78f1ab0f7e1d9d'
    };
    var request = http.Request('GET', Uri.parse('https://www.globalpetrolprices.com/api_gpp.php?cnt=AF,DZ,AD,AR,AW,AU,AT,BS,BB,BY,BE,BZ,BJ,BO,BA,BR,BG,BF,MM,KH,CM,CA,CV,KY,CL,CN,CO,CR,HR,CY,CZ,DK,DO,EC,EG,SV,EE,FJ,FI,FR,GE,DE,GH,GR,GD,GT,GY,HN,HK,HU,IS,IN,ID,IE,IL,IT,CI,JM,JP,JO,KE,KW,KG,LA,LV,LB,LS,LT,LU,MK,MG,MW,MY,MT,MU,YT,MX,MD,ME,MZ,NA,NP,NL,NZ,NI,NO,OM,PK,PA,PE,PH,PL,PT,PR,QA,RO,RU,RW,LC,SA,RS,SL,SG,SK,SI,ZA,KR,ES,LK,SR,SE,CH,TW,TZ,TH,TG,TN,TR,UA,AE,GB,UY,US,VN,WF,ZM,ZW&ind=gp&prd=latest&uid=2804&uidc=98cf0bc91cb47d11f4bd82c9af744ea2'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     // print(await response.stream.bytesToString());

    var data = await response.stream.bytesToString();
        xml2Json.parse(data);
        var jsondata = xml2Json.toParkerWithAttrs();
        lists = json.decode(jsondata);
        var list = lists['gpp:data']["gpp:element"];
        print("2222222222222222"+list.toString());
        return (list as List).cast<Map<String, dynamic>>().map((e) => GppElement.fromJson(e)).toList();

    }
    else {
      print(response.reasonPhrase);
    }
  }
}
