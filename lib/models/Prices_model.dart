// To parse this JSON data, do
//
//     final pricesModel = pricesModelFromJson(jsonString);

import 'dart:convert';

PricesModel pricesModelFromJson(String str) => PricesModel.fromJson(json.decode(str));

String pricesModelToJson(PricesModel data) => json.encode(data.toJson());

class PricesModel {
  PricesModel({
    this.gppData,
  });

  GppData gppData;

  factory PricesModel.fromJson(Map<String, dynamic> json) => PricesModel(
    gppData: GppData.fromJson(json["gpp:data"]),
  );

  Map<String, dynamic> toJson() => {
    "gpp:data": gppData.toJson(),
  };
}

class GppData {
  GppData({
    this.xmlnsGpp,
    this.gppElement,
  });

  String xmlnsGpp;
  List<GppElement> gppElement;

  factory GppData.fromJson(Map<String, dynamic> json) => GppData(
    xmlnsGpp: json["_xmlns:gpp"],
    gppElement: List<GppElement>.from(json["gpp:element"].map((x) => GppElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_xmlns:gpp": xmlnsGpp,
    "gpp:element": List<dynamic>.from(gppElement.map((x) => x.toJson())),
  };
}

class GppElement {
  GppElement({
    this.gppCountry,
    this.gppDate,
    this.gppCurrency,
    this.gppGasoline,
  });

  GppCountry gppCountry;
  DateTime gppDate;
  String gppCurrency;
  String gppGasoline;

  factory GppElement.fromJson(Map<String, dynamic> json) => GppElement(
    gppCountry: GppCountry.fromJson(json["gpp:country"]),
    gppDate: DateTime.parse(json["gpp:date"]),
    gppCurrency: json["gpp:currency"],
    gppGasoline: json["gpp:gasoline"],
  );

  Map<String, dynamic> toJson() => {
    "gpp:country": gppCountry.toJson(),
    "gpp:date": "${gppDate.year.toString().padLeft(4, '0')}-${gppDate.month.toString().padLeft(2, '0')}-${gppDate.day.toString().padLeft(2, '0')}",
    "gpp:currency": gppCurrency,
    "gpp:gasoline": gppGasoline,
  };
}

class GppCountry {
  GppCountry({
    this.code,
    this.value,
  });

  String code;
  String value;

  factory GppCountry.fromJson(Map<String, dynamic> json) => GppCountry(
    code: json["_code"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "_code": code,
    "value": value,
  };
}
