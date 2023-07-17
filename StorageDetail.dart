import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:StorageDetailPage(),debugShowCheckedModeBanner: false,));
}

class StorageDetailPage extends StatefulWidget {
  const StorageDetailPage({super.key});
  // This widget is the root of your application.
  @override
  State <StorageDetailPage> createState()=> StorageDetailPageState();
}

class StorageDetailPageState extends State<StorageDetailPage> {
  // const RegisterPageState({});
  late String id = "B7xO5D0F42Oa2FeVDz0t"; // BU ID FİREBASEDEKİ İLANIN İDSİ. BİR ÖNCEKİ SAYFADAN GÖNDERİLECEK.
  late String title = "";
  late int price = 0;
  late int m2 = 0;
  late String location = "";
  late String description = "";
  late String creator = "";
  List<dynamic> links = [];
  CollectionReference storageCollection = FirebaseFirestore.instance.collection('Storages');
  DocumentSnapshot<Map<String, dynamic>>? documentSnapshot;

  @override
  void initState() {
    super.initState();
    print(id);
    getDocumentById(id);
  }

  Future<void> getDocumentById(String documentId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('Storages').doc(documentId).get();

    setState(() {
      documentSnapshot = snapshot;
      print("-**-*-**");
      print(documentSnapshot?.get("title"));
      title = documentSnapshot!["title"];
      creator = documentSnapshot!["creator"];
      location = documentSnapshot!["location"];
      price = documentSnapshot!["price"];
      m2 = documentSnapshot!["m2"];
      description = documentSnapshot!["definition"];
      links = documentSnapshot!["images"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Text("$title",style: GoogleFonts.ubuntuCondensed(
              textStyle: TextStyle(color: Colors.black,fontSize: 30),),
            ),
            TextButton(child: Text("İlan Sahibi: $creator ",style: GoogleFonts.ubuntuCondensed(
              textStyle: TextStyle(color: Colors.black,fontSize: 18),)),
              onPressed: ()
            {
              //ilan sahibinin profili görüntülenecek. Navigator kullanılacak.
            },
            ),
            SizedBox(height: 25,),
            CarouselSlider(
              options: CarouselOptions(height: 300.0),
              items: links.map((i) {
                return Builder(
                  builder: (BuildContext context) {

                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.amber
                        ),
                        child: Image.network(i),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20,),
            Row(children: [
              Text("Ücret:  ",style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20) ),),
              Text(price.toString() + " TRY",style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20,fontWeight:FontWeight.bold) ))
              ],),
            SizedBox(height: 10,),
            Row(children: [
              Text("m^2:  ",style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20) ),),
              Text(m2.toString(),style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20,fontWeight:FontWeight.bold) ))
            ],),
            SizedBox(height: 10,),
            Row(children: [
              Text("Konum:  ",style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20) ),),
              Text(location,style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20,fontWeight:FontWeight.bold) ))
            ],),
            SizedBox(height: 10,),
            Divider(color: Colors.black,height: 5,),
            Text("Açıklama:  ",style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20,fontWeight:FontWeight.bold) ),),
            SizedBox(height: 10,),
            Column(
              children: [
                Text(description,style: GoogleFonts.ubuntuCondensed(textStyle:TextStyle(fontSize: 20) )),
              ],
            )


          ],)
          ,),
      ),
    );
  }
}