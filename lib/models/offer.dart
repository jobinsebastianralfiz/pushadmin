import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String title;
  final String description;
  final double price;
  final DateTime createdAt;
  final bool isActive;
  final String? category;
  final String? imageUrl;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.createdAt,
    this.isActive = true,
    this.category,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'price': price,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
        'category': category,
        'imageUrl': imageUrl,
      };

  factory Offer.fromJosn(Map<String, dynamic> json,
      {required String documentId}) {
    return Offer(
      id: documentId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String
              ? DateTime.parse(json['createdAt'])
              : (json['createdAt'] as Timestamp).toDate())
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }
}
