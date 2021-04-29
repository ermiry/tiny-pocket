import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:favicon/favicon.dart' as favicon;

class Place {
  final String id;

  String name;
  String description;
  String type;
  String link;
  String logo;
  favicon.Icon iconLogo;

  Color color;

  Place({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.type,
    @required this.color,
    this.link,
    this.logo,
    this.iconLogo,
  });

  Place.fromApp({
    @required this.name,
    @required this.description,
    @required this.type,
    @required this.color,
    this.link,
    this.logo,
    this.id = "",
  });

  static Color _colorFromJson(String colorString) {
    if(colorString  == null) return Colors.black;
    // String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    // return new Color(int.parse(valueString, radix: 16));
    
    return Color(hexToInt(colorString));
  }

  static int hexToInt(String hex){
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  Future<favicon.Icon> getIcon() async {
    if(this.link != null) return await favicon.Favicon.getBest(this.link);
    else return null;
  }

  factory Place.fromJson(dynamic json) {
    if (json["site"] == null) {
      json["site"] = {
        "link": null,
        "logo": null
      };
    }

    return new Place(
      id: json["_id"]["\$oid"],
      name: json["name"],
      description: json["description"],
      color: _colorFromJson(json["color"]),
      type: json["type"] == 0 ? "none": json["type"] == 1 ? "place" : "site",
      link: json["site"]["link"],
      logo: json["site"]["logo"],
    );
  }

  Map<String,dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "description": this.description,
      "color": this.color.value.toRadixString(16),
      "type": this.type == "place" ? "1" : "2",
      "link": this.link??"",
      "logo": this.logo??""
    };
  }

  
}