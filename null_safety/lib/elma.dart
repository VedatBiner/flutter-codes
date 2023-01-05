import 'eatable.dart';
import 'squeezable.dart';

class Elma implements Squeezable, Eatable{
  // iki interface bu şekilde ekleniyor
  @override
  void howToEat() {
    print("Dilimle ve ye");
  }

  @override
  void howToSqueeze() {
    print("Blender ile sık");
  }
}
