class RenkMetod implements HexaColorConvertColor{

  static int HexaColorConverter(String colorHex){
    return int.parse(colorHex.replaceAll("#", "0xff"));
  }
}

class HexaColorConvertColor{
  static int? HexaColorConverter(String? colorHex){
    return null;
  }
}

