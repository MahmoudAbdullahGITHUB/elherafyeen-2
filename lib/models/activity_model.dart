class ActivityModel {
  int id;
  int userId;
  int subjectId;
  String description;
  String name;
  String photo;
  String createdAt;
  bool isOnline;
  bool isAdded;

  ActivityModel(
      {this.id,
      this.userId,
      this.subjectId,
      this.description,
      this.createdAt,
      this.name,
      this.photo,
      this.isOnline,
      this.isAdded});

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json['id'] ?? 0,
        userId: json['causer_id'] ?? 0,
        subjectId: json['subject_id'] ?? 0,
        description: json['description'] ?? "",
        name: json['causer']['name'] ?? "",
        photo: json['causer']['photo'] ?? "",
        createdAt: json['created_at'] ?? "",
        isOnline: json['is_online'] ?? false,
        isAdded: false,
      );

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return new ActivityModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      subjectId: map['subjectId'] as int,
      description: map['description'].toString(),
      name: map['name'].toString(),
      photo: map['photo'].toString(),
      createdAt: map['createdAt'].toString(),
      isOnline: map['is_online'] ?? false,
      isAdded: false,
    );
  }

  Map<String, dynamic> toJson() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'userId': this.userId,
      'subjectId': this.subjectId,
      'description': this.description,
      'name': this.name,
      'photo': this.photo,
      'createdAt': this.createdAt,
      'is_online': this.isOnline,
    } as Map<String, dynamic>;
  }

  factory ActivityModel.fromUser(Map<String, dynamic> json) => ActivityModel(
        id: json['id'] ?? 0,
        userId: json['id'] ?? 0,
        subjectId: json['id'] ?? 0,
        description: json['bio'] ?? "",
        name: json['name'] ?? "",
        photo: json['photo'] ?? "",
        createdAt: json['created_at'] ?? "",
        isOnline: json['is_online'] ?? false,
        isAdded: false,
      );
}
