class UsersModel {
  String? displayName;
  String? bio;
  String? id;

  UsersModel({this.displayName, this.bio, this.id});

  UsersModel.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    bio = json['bio'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['bio'] = bio;
    data['id'] = id;
    return data;
  }

  @override
  String toString() {
    return 'UsersModel{displayName: $displayName, bio: $bio, id: $id}';
  }
}
