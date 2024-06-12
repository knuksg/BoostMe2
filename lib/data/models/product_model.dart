import 'package:boostme2/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.stockQuantity,
    required super.soldQuantity,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      final product = ProductModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: double.parse(json['price']), // Parse the string to a double
        imageUrl: json['image_url'],
        stockQuantity: json['stock_quantity'],
        soldQuantity: json['sold_quantity'],
        category: json['category'],
      );

      return product;
    } catch (e, stackTrace) {
      debugPrint('Error in ProductModel.fromJson: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow; // Re-throw the exception after logging it
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'stock_quantity': stockQuantity,
      'sold_quantity': soldQuantity,
      'category': category,
    };
  }
}
