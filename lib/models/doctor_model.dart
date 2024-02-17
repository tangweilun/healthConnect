// ignore_for_file: public_member_api_docs, sort_constructors_first
class Doctor {
  final String id;
  final String name;
  final String description;
  final String category;
  final String experience;
  final String rating;
  final String image;
  // Add more properties as needed

  Doctor({
    // Add more properties as needed
    this.id = '',
    this.name = '',
    this.category = '',
    this.experience = '',
    this.rating = '',
    this.image = '',
    this.description = '',
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        category: json['category'] ?? '',
        experience: json['experience'] ?? '',
        rating: json['rating'] ?? '',
        image: json['image'] ?? '',
        description: json['description'] ?? '',
        // Parse more properties as needed
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'experience': experience,
        'rating': rating,
        'image': image,
        'description': description,
        // Add more properties as needed
      };
}
