class Report {
  final int id;
  final double longitude;
  final double latitude;

  final String image;
  final String description;

  Report({
    this.id,
    this.description,
    this.image,
    this.longitude,
    this.latitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  Report.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        description = res["description"],
        image = res["image"],
        longitude = res["longitude"],
        latitude = res["latitude"];

  @override
  String toString() {
    return 'Report{id: $id, description: $description, image: $image, longitude: $longitude, latitude: $latitude}';
  }
}
