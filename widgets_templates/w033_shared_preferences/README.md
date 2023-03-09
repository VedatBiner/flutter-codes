# w033_shared_preferences

shared_preferences template

Verinin oluşması için : var sp = await SharedPreferences.getInstance(); kullanılıyor.

Veri Kaydı için set metodları kullanılıyor. Sadece 5 metod var.
* sp.setString("key", "value");
* sp.setInt("key", value);
* sp.setDouble("key", value);
* sp.setBool("key", value);
* sp.setStringList("key", valueList);

Veri okumak için get metodları kullanılıyor. Sadece 5 metod var.
* sp.getString("key", "value");
* sp.getInt("key", value);
* sp.getDouble("key", value);
* sp.getBool("key", value);
* sp.getStringList("key", valueList);\

Veri silmek için remove metodu kullanılıyor. 
* sp.remove("key");

Veri güncelleme get metodları ile veri okuma gibi yapılıyor. 

burada önemli olan key bilgilerinin doğru kullanılmasıdır.