import 'package:shared/libraries/equatable_export/equatable_export.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final ProductRating rating;

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    imageUrl,
    rating,
  ];
}

class ProductRating extends Equatable {
  const ProductRating({required this.rate, required this.count});

  final double rate;
  final int count;

  @override
  List<Object?> get props => [rate, count];
}
