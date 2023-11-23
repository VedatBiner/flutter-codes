/// <----- character_query.dart ----->
String readCharacters ="""
query CharacterNameAndImage{
    characters{
      results{
      id
      name
      image
      }
    }
}
""";

String readCharacterById = """
query CharacterById(\$characterId : [ID!]!){
   charactersByIds(ids:\$characterId) {
     id
    name
    image
    gender
    species
    episode{
      name
      episode
      id
    }
   }
}
""";
