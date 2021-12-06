import 'dart:convert';


class PlaceDetail {
  String icon;
  String id;
  String name;
  String rating;
  String vicinity;
  String formatted_address;
  String international_phone_number;
  List<String> weekday_text;
  String url;

  PlaceDetail(this.id, this.name, this.icon, this.rating, this.vicinity,
      [this.formatted_address,
      this.international_phone_number,
      this.weekday_text]);
}


// To parse this JSON data, do
//
//     final placesModel = placesModelFromJson(jsonString);


PlacesModel placesModelFromJson(String str) => PlacesModel.fromJson(json.decode(str));

String placesModelToJson(PlacesModel data) => json.encode(data.toJson());

class PlacesModel {
  PlacesModel({
    this.htmlAttributions,
    this.nextPageToken,
    this.results,
    this.status,
  });

  List<dynamic> htmlAttributions;
  String nextPageToken;
  List<Result> results;
  String status;

  factory PlacesModel.fromJson(Map<String, dynamic> json) => PlacesModel(
    htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
    nextPageToken: json["next_page_token"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
    "next_page_token": nextPageToken,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "status": status,
  };
}

class Result {
  Result({
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.reference,
    this.scope,
    this.types,
    this.vicinity,
    this.businessStatus,
    this.plusCode,
    this.rating,
    this.userRatingsTotal,
    this.openingHours,
  });

  Geometry geometry;
  String icon;
  IconBackgroundColor iconBackgroundColor;
  String iconMaskBaseUri;
  String name;
  List<Photo> photos;
  String placeId;
  String reference;
  Scope scope;
  List<String> types;
  String vicinity;
  BusinessStatus businessStatus;
  PlusCode plusCode;
  double rating;
  int userRatingsTotal;
  OpeningHours openingHours;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: iconBackgroundColorValues.map[json["icon_background_color"]],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    photos: json["photos"] == null ? null : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    placeId: json["place_id"],
    reference: json["reference"],
    scope: scopeValues.map[json["scope"]],
    types: List<String>.from(json["types"].map((x) => x)),
    vicinity: json["vicinity"],
    businessStatus: json["business_status"] == null ? null : businessStatusValues.map[json["business_status"]],
    plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
    rating: json["rating"] == null ? null : json["rating"].toDouble(),
    userRatingsTotal: json["user_ratings_total"] == null ? null : json["user_ratings_total"],
    openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
  );

  Map<String, dynamic> toJson() => {
    "geometry": geometry.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColorValues.reverse[iconBackgroundColor],
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "photos": photos == null ? null : List<dynamic>.from(photos.map((x) => x.toJson())),
    "place_id": placeId,
    "reference": reference,
    "scope": scopeValues.reverse[scope],
    "types": List<dynamic>.from(types.map((x) => x)),
    "vicinity": vicinity,
    "business_status": businessStatus == null ? null : businessStatusValues.reverse[businessStatus],
    "plus_code": plusCode == null ? null : plusCode.toJson(),
    "rating": rating == null ? null : rating,
    "user_ratings_total": userRatingsTotal == null ? null : userRatingsTotal,
    "opening_hours": openingHours == null ? null : openingHours.toJson(),
  };
}

enum BusinessStatus { OPERATIONAL }

final businessStatusValues = EnumValues({
  "OPERATIONAL": BusinessStatus.OPERATIONAL
});

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Locations location;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Locations.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "viewport": viewport.toJson(),
  };
}

class Locations {
  Locations({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Locations northeast;
  Locations southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Locations.fromJson(json["northeast"]),
    southwest: Locations.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}

enum IconBackgroundColor { THE_7_B9_EB0, F88181, FF9_E67, THE_4_B96_F3 }

final iconBackgroundColorValues = EnumValues({
  "#F88181": IconBackgroundColor.F88181,
  "#FF9E67": IconBackgroundColor.FF9_E67,
  "#4B96F3": IconBackgroundColor.THE_4_B96_F3,
  "#7B9EB0": IconBackgroundColor.THE_7_B9_EB0
});

class OpeningHours {
  OpeningHours({
    this.openNow,
  });

  bool openNow;

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["open_now"],
  );

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
  };
}

class Photo {
  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    height: json["height"],
    htmlAttributions: List<String>.from(json["html_attributions"].map((x) => x)),
    photoReference: json["photo_reference"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
    "photo_reference": photoReference,
    "width": width,
  };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String compoundCode;
  String globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}

enum Scope { GOOGLE }

final scopeValues = EnumValues({
  "GOOGLE": Scope.GOOGLE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
