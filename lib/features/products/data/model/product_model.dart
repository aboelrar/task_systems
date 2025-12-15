import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.image,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      price: (json['price'] as num).toDouble(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
  }

  static List<ProductModel> listFromJson(List<dynamic> json) {
    return json.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<ProductModel> list) {
    return list.map((e) => e.toJson()).toList();
  }
}