import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/* GEÇİCİ OLARAK MAİN DEVRE DIŞI. BİRLEŞTİRME SIRASINDA ZATEN KULLANILMAYACAK.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:RegisterPage()));
}*/

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  // This widget is the root of your application.
  @override
  State <RegisterPage> createState()=> RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // const RegisterPageState({});
  final  namecontroller = TextEditingController();
  final  surnamecontroller = TextEditingController();
  final  passwordcontroller = TextEditingController();
  final  password2controller = TextEditingController();
  final  mailcontroller = TextEditingController();
  final  phonecontroller = TextEditingController();
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Kayıt Ekranı"
            ),
          ),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child:Padding(padding: EdgeInsets.symmetric(vertical:5.0),child:
            Column(
              children: [
                SizedBox(width: 250,child: TextField(controller: namecontroller,
                decoration: InputDecoration(labelText: "İsminizi Giriniz",border: OutlineInputBorder()),),),
                SizedBox(height: 20,),
                SizedBox(width: 250,child: TextField(controller: surnamecontroller,
                  decoration: InputDecoration(labelText: "Soyadınızı Giriniz",border: OutlineInputBorder()),),),
                SizedBox(height: 20,),
                SizedBox(width: 250,child: TextField(controller: passwordcontroller,
                  decoration: InputDecoration(labelText: "Şifrenizi Giriniz",border: OutlineInputBorder(),),obscureText:true ),),
                SizedBox(height: 20,),
                SizedBox(width: 250,child: TextField(controller: password2controller,
                  decoration: InputDecoration(labelText: "Tekrar Şifrenizi Giriniz",border: OutlineInputBorder()),obscureText:true,),),
                SizedBox(height: 20,),
                SizedBox(width: 250,child: TextField(controller: mailcontroller,
                  decoration: InputDecoration(labelText: "Mail Adresinizi Giriniz",border: OutlineInputBorder()),),),
                SizedBox(height: 20,),
                SizedBox(width: 250,child: TextField(controller: phonecontroller,keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Telefon Numaranızı Giriniz",border: OutlineInputBorder()),),),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: register, child: Text("Kayıt Ol"),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)),)

              ],
            ),
            )
          ),
        ),
      );

  }
  Future<void> register() async{
    print("test");
    if(namecontroller.text == "" || passwordcontroller.text == "" || password2controller.text == ""
        || surnamecontroller.text == "" || mailcontroller.text == ""){
      showMyDialogFieldEmpty();
    }
    else if(passwordcontroller.text!=password2controller.text){
      showDialogpasswordmatch();
    }
    else if(passwordcontroller.text.length<6){
      showDialogPassword_min_length();
    }
    else {
      print("tel kontrol start");
      if(await checkPhoneNumber(phonecontroller.text) && await checkMail(mailcontroller.text) ){
          print("kayıt start");
          List<int> passwordBytes = utf8.encode(passwordcontroller.text);
          Digest hashedPassword = sha256.convert(passwordBytes);
          // Yeni kullanıcıyı Firestore'a kaydet
          await usersCollection.add({
            'email': mailcontroller.text,
            'location': null,
            'name': namecontroller.text,
            'surname':surnamecontroller.text,
            'phone': phonecontroller.text,
            'password': hashedPassword.toString()

          }).then((value) => showMyDialogRegistrationOK()).catchError((error) => print(error));

          print('Kullanıcı başarıyla kaydedildi!');
          Navigator.of(context).pop();

      }
    }
 }
 Future<void> showMyDialogFieldEmpty() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Alanların tamamını doldurduğunuza emin olun.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showMyDialogRegistrationOK() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Kaydınız başarıyla tamamlandı.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void>  showDialogpasswordmatch() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Girdiğiniz şifreler uyuşmuyor.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showDialogPassword_min_length() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Şifreniz en az 6 karakterli olmalıdır.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showDialogMail() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bu mail zaten kullanımda.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogPhone() async {
    print("test2");
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bu telefon numarası zaten kullanımda.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      // Belirtilen telefon numarasına sahip kullanıcıları sorgula
      QuerySnapshot querySnapshot = await usersCollection.where('phone', isEqualTo: phoneNumber).get();

      // Eğer başka kullanıcılar varsa, kayıt işlemini engelle
      if (querySnapshot.docs.isNotEmpty) {
        print('Bu telefon numarası zaten kullanımda!');
        showDialogPhone();
        return false;
      }else{
        return true;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }


  Future<bool> checkMail(String mail) async {
    try {
      // Belirtilen telefon numarasına sahip kullanıcıları sorgula
      QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: mail).get();

      // Eğer başka kullanıcılar varsa, kayıt işlemini engelle
      if (querySnapshot.docs.isNotEmpty) {
        print('Bu mail zaten kullanımda!');
        showDialogMail();
        return false;
      }else{
        return true;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

}





