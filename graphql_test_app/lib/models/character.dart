/// <----- character.dart ----->
class Character {
  String? id;
  String? name;
  String? image;

  Character({this.id, this.name, this.image});

  Character.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
