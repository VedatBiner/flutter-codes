# sozluk_appv2_ser_tr_sqflite

Bu uygulama da daha önce yaptığımız Sırpça-Türkçe uygulamanın
yeni versiyonunu yapıyoruz. Burada verilerimiz Firebase Firestore
üzerinde olacak. Ama Asıl çalışma alanımız lokal veri tabanı ile çalışıp,
sqflite kullanıp, önemli değişiklikler olursa Firestore 'a verileri yazıp,
gereksiz trafiği azaltmak, performans arttırmak ve ücretlendirmeden kaçınmak olacak.
Firestore verisinin JSON olarak lokal disk ve sanal cihazda yedeklenmesi sağlandı
