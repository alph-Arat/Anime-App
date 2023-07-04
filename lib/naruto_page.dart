import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


late Future<Album> futureAlbum;

Future<Album> getData(int myId) async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'laravel_session=V1M9t05VmT6QnSngN5OxJTzN7NjdsBo0pXWiR7sh',
    'Charset': 'utf-8',
  };
  var request = http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
  request.body =
      '''{"query":"{\\r\\n  \\r\\nCharacter(id: 17){\\r\\n\\tname {\\r\\n\\t  first\\r\\n\\t  middle\\r\\n\\t  last\\r\\n\\t  full\\r\\n\\t  native\\r\\n\\t} \\r\\n  gender\\r\\n  image {\\r\\n    large\\r\\n    medium\\r\\n  }\\r\\n  dateOfBirth {\\r\\n    year\\r\\n    month\\r\\n    day\\r\\n  }\\r\\n  age\\r\\n  description\\r\\n  }\\r\\n \\r\\n\\r\\n}","variables":{}}''';

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
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
  Album(
      {required this.full,
      required this.first,
      required this.last,
      required this.gender,
      required this.day,
      required this.month,
      required this.age,
      required this.description,
      });

  factory Album.fromJson(Map<String, dynamic> json) {
    print(json['data']['Character']['description']);
    return Album(
      first: json['data']['Character']['name']['first'],
      full: json['data']['Character']['name']['full'],
      last: json['data']['Character']['name']['last'],
      gender: json['data']['Character']['gender'],
      month: json['data']['Character']['dateOfBirth']['month'],
      day: json['data']['Character']['dateOfBirth']['day'],
      age: json['data']['Character']['age'],
      description: json['data']['Character']['description']
    );
  }
}

class NarutoPage extends StatefulWidget {
  const NarutoPage({Key? key}) : super(key: key);

  @override
  _NarutoPageState createState() => _NarutoPageState();
}

class _NarutoPageState extends State<NarutoPage> {
  @override
  void initState() {
    super.initState();
    futureAlbum = getData(17);
  }
  String newDescription = '';

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
      body: Container(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                  "https://s4.anilist.co/file/anilistcdn/character/medium/b17-IazKGogQwJ1p.png"),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('First Name: '),
                  FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.first);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Last Name: '),
                  FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.last);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Full Name: '),
                  FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.full);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Gender: '),
                  FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.gender);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Birthday: '),
                  FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                              '${snapshot.data!.month}/${snapshot.data!.day}');
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Age: '),
                  FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data!.age}');
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('${snapshot.data!.description.replaceAll('_', newDescription).replaceAll('~!', newDescription).replaceAll('(https://anilist.co/character/2535)', newDescription).replaceAll('(https://anilist.co/character/7302)', newDescription).replaceAll('(https://anilist.co/character/2423)', newDescription).replaceAll('(https://anilist.co/character/7407)', newDescription).replaceAll('!~', newDescription)}');
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
