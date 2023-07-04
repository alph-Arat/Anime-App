import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
late Future<Album> futureAlbum;
Future<Album> getObito() async {
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'laravel_session=6cbKkMLsawFdyl0IqyChHwtrQb3jIu3bXdPigNjJ',
  'Charset': 'utf-8',
  };
  var request = http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
  request.body = '''{"query":"{\\r\\n  \\r\\nCharacter(id: 2910){\\r\\n\\tname {\\r\\n\\t  first\\r\\n\\t  last\\r\\n\\t  full\\r\\n\\t  native\\r\\n\\t} \\r\\n  gender\\r\\n  image {\\r\\n    large\\r\\n  }\\r\\n  dateOfBirth {\\r\\n    month\\r\\n    day\\r\\n  }\\r\\n  description\\r\\n  }\\r\\n \\r\\n\\r\\n}","variables":{}}''';

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    return Album.fromJson(jsonDecode(data));
  }
  else {
  throw Exception('Failed to load album');
  }

}
class Album{
  final String full;
  final String first;
  final String last;
  final String gender;
  final int month;
  final int day;
  final String description;
  Album(
      {required this.full,
        required this.first,
        required this.last,
        required this.gender,
        required this.day,
        required this.month,
        required this.description,
      });
factory Album.fromJson(Map<String, dynamic> json){
  print(json['data']['Character']['name']['last'],);
  return Album(
      first: json['data']['Character']['name']['first'],
      full: json['data']['Character']['name']['full'],
      last: json['data']['Character']['name']['last'],
      gender: json['data']['Character']['gender'],
      month: json['data']['Character']['dateOfBirth']['month'],
      day: json['data']['Character']['dateOfBirth']['day'],
      description: json['data']['Character']['description']
  );
}
}
class ObitoPage extends StatefulWidget {
  const ObitoPage({Key? key}) : super(key: key);

  @override
  _ObitoPageState createState() => _ObitoPageState();
}

class _ObitoPageState extends State<ObitoPage> {
  @override
  void initState() {
    super.initState();
    futureAlbum = getObito();
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
      body: Container(
        width: 450,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                  "https://s4.anilist.co/file/anilistcdn/character/large/b2910-xQFeZZWZWTB2.jpg"),
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
              SizedBox(height: 20),
              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('${snapshot.data!.description}');
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
