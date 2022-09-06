import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_tutorial/models/ogrenci.dart';

class MyHiveServices {
  Future<void> increment() async {
    await Hive.openBox('test'); // openbox ile kutu açılır

    var box = Hive.box('test');
    await box.clear();
    await box.add('emre'); //0.index in valuesi olarak kayıt edilir
    await box.add('altun'); //1.index
    await box.add(24); //2.index
    await box.add(true); //3.index

    await box.put('tc',
        312312341512); //eğer put ile veri eklersek key-value şeklinde kaydedilir .
    await box.put(
        'meslek', 'eczacı'); // {'meslek':'eczacı'} olarak kayıt edilir

    // özetle add liste olarak kayıt ediyor put ise map olarak

    await box.addAll([
      'liste1',
      'liste2',
      true,
      false,
      33
    ]); // tüm listeyi kayıt etmek için addAll
    await box.putAll({
      'yas': 25,
      'adres': {
        'il': 'mersin',
        'ilce': 'yenisehir',
        'plaka': 33,
      }
    }); // tüm mapi kayıt etmek için putAll
    await box.delete('tc'); // delete
    await box.put(
        'yas', 44); // put ile key istenen keydeki veri güncellenebilir
    debugPrint(box.toMap().toString()); // tüm box'ı mape çevirir
    debugPrint(box.get(0).toString()); // index ile veriyi okuma
    debugPrint(box.getAt(1).toString()); // index ile veriyi okuma
    debugPrint(box.get('adres').toString()); // key ile veriyi okuma
  }

  Future<void> myTypeAdapter() async {
    Hive.registerAdapter(
        OgrenciAdapter()); //hivede olmayan veri türlerini(objeler vs.) kayıt etmek için registerAdapter ile önce hive e kayıt edilir
    Hive.registerAdapter(GozRenkAdapter());
    await Hive.openBox<Ogrenci>('ogrenciler');
    var emre = Ogrenci(1, 'emre', GozRenk.MAVI); //1.nesne
    var ahmet = Ogrenci(2, 'ahmet', GozRenk.SIYAH); //2.nesne
    var myBox = Hive.box<Ogrenci>('ogrenciler'); //kutuyu mybox a attık
    await myBox.clear();
    myBox.add(
        emre); //önceden RegisterAdapter ile veri türünü hive e ögrettigimiz için artık bu nesneleri kayıt edebiliyor
    myBox.add(ahmet);
    debugPrint(myBox.toMap().toString());
  }

  // normal box= tüm verileri tek seferde çeker sonra çektigi yerden okur - hızlıdır
  // lazy box = verileri tek tek çeker normal box' a göre yavaştır fakat veri çok çok fazlaysa lazy box avantajdır

  Future<void> lazyAndEncryptedBox() async {
    //lazy box
    await Hive.openLazyBox<int>('sayilar');
    var sayilar = Hive.lazyBox<int>('sayilar');
    for (int i = 0; i < 100; i++) {
      await sayilar.add(i * 5);
    }

    for (int i = 0; i < 100; i++) {
      debugPrint((await sayilar.getAt(i)).toString());
    }
  }

  Future<void> encryptedBox() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();

    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64Encode(key));
    }
    var encryptionKey =
        base64Url.decode(await secureStorage.read(key: 'key') ?? 'bos');
    print('Encryption Key :  $encryptionKey ');

    var sifreliKutu = await Hive.openBox('ozel',
        encryptionCipher: HiveAesCipher(encryptionKey));
    await sifreliKutu.put('secret', 'hive is cool');
    await sifreliKutu.put('sifre', 23121);
    print(sifreliKutu.get('sifre').toString());
  }
}

// eğer çok sık silme-yazma işlemi yapıyorsak aşagıdaki gibi openbox yaptıgımızda silinen boşlukları sıkıştırıp doldurabilir.

/*

var box=await Hive.openBox('myBox',compactionStrategy:(entries,deletedEntries)
{
  return deletedEntries>50;
  
});


*/