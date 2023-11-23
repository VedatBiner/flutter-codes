/// <----- character_detail_model.dart ----->
class CharacterDetailModel {
  String? id;
  String? name;
  String? image;
  String? gender;
  String? species;
  List<Episode>? episode;

  CharacterDetailModel(
      {this.id,
      this.name,
      this.image,
      this.gender,
      this.species,
      this.episode});

  CharacterDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    gender = json['gender'];
    species = json['species'];
    if (json['episode'] != null) {
      episode = <Episode>[];
      json['episode'].forEach((v) {
        episode!.add(Episode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['gender'] = gender;
    data['species'] = species;
    if (episode != null) {
      data['episode'] = episode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Episode {
  String? name;
  String? episode;
  String? id;

  Episode({this.name, this.episode, this.id});

  Episode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    episode = json['episode'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['episode'] = episode;
    data['id'] = id;
    return data;
  }
}
