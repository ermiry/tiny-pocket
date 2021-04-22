import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocket/models/http_exception.dart';
import 'package:pocket/models/place.dart';
import 'package:pocket/values.dart';

class Places with ChangeNotifier {
  List <Place> _places = [];

  List <Place> get places => _places;

  int _selectedPlaceIdx = 0;

  int get selectedPlaceIdx => this._selectedPlaceIdx;

  set selectedPlaceIdx (int val) {
    this._selectedPlaceIdx = val;
    notifyListeners();
  }

  Place getById(String id){
    return this._places.firstWhere((element) => (element.id == id), orElse: () => null);
  }

  Future <void> fetch(String token) async {
    try {
      final res = await http.get(Uri.parse(serverURL + "/api/pocket/places"),
        headers: {
          "Authorization": token
        }
      );

      switch(res.statusCode) {
        case 200:
          var placesJson = json.decode(res.body);
          print(placesJson);
          this._places = placesJson["places"].map<Place>((place) => Place.fromJson(place)).toList();

          for(Place place in this._places) {
            place.iconLogo = await place.getIcon();
          }
          
          notifyListeners();
        break;
        default:
          throw HttpException(res.body);
      }
    }catch(error) {
      print(error.toString());
      throw HttpException(error.toString(), code: Code.Place);
    }
  }

  Future <void> add(Place place, String token) async {
    final url = serverURL + "/api/pocket/places";
    try{
      final res = await http.post(Uri.parse(url), 
        headers: {"Authorization": token},
        body: json.encode(place.toJson())
      );

      switch(res.statusCode) {
        case 200:
          notifyListeners();
        break;
        default: throw HttpException(res.body);
      }
    }catch(error){
      throw HttpException(error.toString());
    }
  }

  Future<void> update(String id, Place newPlace) async{
    if(id != null) {
      Place place = this._places.firstWhere((element) => (element.id == id));
      place.name = newPlace.name;
      place.description = newPlace.description;
      place.type = newPlace.type;
      place.link = newPlace.link;
      place.logo = newPlace.logo;
    }
  }
}