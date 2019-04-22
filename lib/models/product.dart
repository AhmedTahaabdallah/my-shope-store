import 'package:flutter/material.dart';
import '../models/locationdata.dart';
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String userEmail;
  final String userId;
  final bool isFavorits;
  final LocationData locationData;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userEmail,
      @required this.userId,
      @required this.locationData,
      this.isFavorits = false});
}
