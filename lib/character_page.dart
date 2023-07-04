import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

late Future<Album> futureAlbum;

Future<Album> getCharacter(int id) async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'laravel_session=V1M9t05VmT6QnSngN5OxJTzN7NjdsBo0pXWiR7sh',
    'Charset': 'utf-8',
  };
  var request = http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
  request.body =
      '''{"query":"{\\r\\nCharacter(id: $id){\\r\\n\\tname {\\r\\n\\t  first\\r\\n\\t  last\\r\\n\\t  full\\r\\n\\t  native\\r\\n\\t} \\r\\n  gender\\r\\n  image {\\r\\n    large\\r\\n  }\\r\\n  dateOfBirth {\\r\\n    month\\r\\n    day\\r\\n  }\\r\\n  age\\r\\n  description\\r\\n  }\\r\\n \\r\\n\\r\\n}","variables":{}}''';
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print('DATAAAAAAAAAAAa');
    String data = await response.stream.bytesToString();
    print(data);

    return Album.fromJson(jsonDecode(data));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String full;
  final String first;
  final String last;
  final String gender;
  final int month;
  final int day;
  final String age;
  final String description;
  final String image;
  final String native;

  Album({
    required this.full,
    required this.first,
    required this.last,
    required this.gender,
    required this.day,
    required this.month,
    required this.age,
    required this.description,
    required this.image,
    required this.native,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    print(json['data']['Character']['name']['full']);
    return Album(
      first: json['data']['Character']['name']['first'] != null
          ? json['data']['Character']['name']['first']
          : "",
      native: json['data']['Character']['name']['native'] != null
          ? json['data']['Character']['name']['native']
          : "",
      full: json['data']['Character']['name']['full'] != null
          ? json['data']['Character']['name']['full']
          : "",
      last: json['data']['Character']['name']['last'] != null
          ? json['data']['Character']['name']['last']
          : "",
      gender: json['data']['Character']['gender'] != null
          ? json['data']['Character']['gender']
          : "",
      month: json['data']['Character']['dateOfBirth']['month'] != null
          ? json['data']['Character']['dateOfBirth']['month']
          : 0,
      day: json['data']['Character']['dateOfBirth']['day'] != null
          ? json['data']['Character']['dateOfBirth']['day']
          : 0,
      age: json['data']['Character']['age'] != null
          ? json['data']['Character']['age']
          : "",
      description: json['data']['Character']['description'] != null
          ? json['data']['Character']['description']
          : "",
      image: json['data']['Character']['image']['large'] != null
          ? json['data']['Character']['image']['large']
          : "https://www.nacdnet.org/wp-content/uploads/2016/06/person-placeholder.jpg",
    );
  }
}

class CharacterPage extends StatefulWidget {
  final int id2;

  const CharacterPage({Key? key, required this.id2}) : super(key: key);

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  @override
  void initState() {
    super.initState();
    futureAlbum = getCharacter(widget.id2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.full);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image(
                          image: NetworkImage(snapshot.data!.image),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    }),
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xCC000000),
                        const Color(0x00000000),
                        const Color(0xCC000000),
                        const Color(0xff000a1a),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.full,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  bottom: 40,
                  left: 40,
                ),
                Positioned(
                  child: Row(
                    children: [
                      FutureBuilder<Album>(
                        future: futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.native,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FutureBuilder<Album>(
                        future: futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.gender,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      FutureBuilder<Album>(
                        future: futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!.age,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                  bottom: 28,
                  left: 40,
                ),
              ],
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color(0xff000a1a),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 12, 10, 12),
                      child: Text(
                        'Description of character',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xffdae2f0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: FutureBuilder<Album>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.description.replaceAll('_', '').replaceAll('~!', '').replaceAll('!~', '').replaceAll('~~~', ':').replaceAll('*', ''),
                                style: TextStyle(
                                  color: Color(0xff868e9f),
                                ),
                              );
                            }
                            return CircularProgressIndicator();
                          }),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
