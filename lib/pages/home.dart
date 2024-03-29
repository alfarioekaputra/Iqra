import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Quran>> fetchSurah() async {
  final response =
      await http.get('https://al-quran-8d642.firebaseio.com/data.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Quran> listOfQuran = items.map<Quran>((json) {
      return Quran.fromJson(json);
    }).toList();

    return listOfQuran;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<List<QuranAyat>> fetchAyat(String nomor) async {
  final response = await http
      .get('https://al-quran-8d642.firebaseio.com/surat/${nomor}.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<QuranAyat> listOfQuranAyat = items.map<QuranAyat>((json) {
      return QuranAyat.fromJson(json);
    }).toList();

    return listOfQuranAyat;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Quran {
  final String nama;
  final String nomor;
  final String asma;
  final String arti;
  final String audio;
  final int jumlahAyat;
  final String keterangan;

  Quran(
      {this.nama,
      this.nomor,
      this.asma,
      this.arti,
      this.audio,
      this.jumlahAyat,
      this.keterangan});

  factory Quran.fromJson(Map<String, dynamic> json) {
    return Quran(
        nama: json["nama"],
        nomor: json["nomor"],
        asma: json["asma"],
        arti: json["arti"],
        audio: json["audio"],
        jumlahAyat: json["ayat"],
        keterangan: json["keterangan"]);
  }
}

class QuranAyat {
  final String ar;
  final String id;
  final String nomor;
  final String tr;

  QuranAyat({this.ar, this.id, this.nomor, this.tr});

  factory QuranAyat.fromJson(Map<String, dynamic> json) {
    return QuranAyat(
      ar: json["ar"],
      id: json["id"],
      nomor: json["nomor"],
      tr: json["tr"],
    );
  }
}

class Home extends StatelessWidget {
  final Future<Quran> quran;

  Home({Key key, this.quran}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Quran>>(
        future: fetchSurah(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Card(
            elevation: 8.0,
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.green[300]),
              child: ListView(
                children: snapshot.data
                    .map((quran) => ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(width: 1.0, color: Colors.white24))
                    ),
                    child: Icon(Icons.play_arrow, color: Colors.white,),
                  ),
                  title: Text(
                    quran.asma,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
                  ),
                  subtitle: Text(quran.nama, style: TextStyle(color: Colors.white),),
                  trailing: Icon(Icons.chrome_reader_mode, color: Colors.white,),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Baca(quran.nomor, quran.nama)));
                  },
                ))
                    .toList(),
              ),
            ),
          );

        },
      ),
    );
  }
}

class Baca extends StatelessWidget {
  final Future<QuranAyat> quranAyat;
  final String nomor;
  final String nama;
  Baca(this.nomor, this.nama, {Key key, this.quranAyat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.nama),
      ),
      body: FutureBuilder<List<QuranAyat>>(
        future: fetchAyat(this.nomor),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data
                .map((quran) =>
                    ListTile(title: Text(quran.ar), subtitle: Text(quran.id)))
                .toList(),
          );
        },
      ),
    );
  }
}
