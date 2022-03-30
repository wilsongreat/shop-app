import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final dynamic id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavState(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    final url = Uri.parse(
        'https://shop-app1-433db-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$token');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      var response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavState(oldStatus);
      }
    } catch (error) {
      _setFavState(oldStatus);
      throw HttpException('Could not add to favourites');
    }
  }
}
