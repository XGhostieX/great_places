import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    final place = Place(
      id: DateTime.now().toString(),
      title: title,
      location: null,
      image: image,
    );
    _items.add(place);
    notifyListeners();
    DBHelper.insert('places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelper.getData('places');
    _items = data
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            image: File(e['image']),
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }
}
