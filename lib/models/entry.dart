import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String id;
  final String title;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final DateTime createdAt;

  Entry({
    required this.id,
    required this.title,
    required this.description,
    this.latitude,
    this.longitude,
    this.imageUrl,
    required this.createdAt,
  });

  
  factory Entry.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;
    
    
    if (json['createdAt'] is Timestamp) {
      createdAt = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      createdAt = DateTime.parse(json['createdAt']);
    } else {
      createdAt = DateTime.now();
    }

    return Entry(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      imageUrl: json['imageUrl'],
      createdAt: createdAt,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  
  Entry copyWith({
    String? id,
    String? title,
    String? description,
    double? latitude,
    double? longitude,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Entry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}