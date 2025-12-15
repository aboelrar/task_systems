import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, price, description, image, category];
}