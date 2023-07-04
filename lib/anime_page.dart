import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'skeleton_container.dart';

bool loading = true;
late Future<Album> futureAlbum;
int idd = 1735;

Future<Album> getAnime(String anime) async {
  if (anime.isEmpty ||  anime == 'null') {
    anime = 'Naruto Shippuden';
  }
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'laravel_session=lrif7ipodQDmnWl8TyldhovojSwUaEDFz72TFNy3'
  };
  var request = http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
  request.body =
      '''{"query":"{\\r\\n  Media(search:\\"$anime\\",type:ANIME){\\r\\n\\t\\tcoverImage {\\r\\n\\t\\t  large\\r\\n\\t\\t  medium\\r\\n\\t\\t}\\r\\n    title {\\r\\n      english\\r\\n      native\\r\\n    }\\r\\n    id\\r\\n  }\\r\\n}","variables":{}}''';
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    print('DATAAAAA');
    print(data);
    return Album.fromJson(jsonDecode(data));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String large;
  final String english;
  final String native;
  final int id;

  Album({
    required this.english,
    required this.large,
    required this.native,
    required this.id,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    print(json['data']['Media']['coverImage']['large']);
    print(json['data']['Media']['title']['english']);
    print(json['data']['Media']['title']['native']);
    print('Other IDD hope it works');
    idd = json['data']['Media']['id'];
    print(idd);
    return Album(
      large: json['data']['Media']['coverImage']['large'],
      english: json['data']['Media']['title']['english'],
      native: json['data']['Media']['title']['native'],
      id: json['data']['Media']['id'],
    );
  }
}

class AnimePage extends StatefulWidget {
  const AnimePage({Key? key}) : super(key: key);

  @override
  _AnimePageState createState() => _AnimePageState();
}

class _AnimePageState extends State<AnimePage> {
  final myController = TextEditingController();

  var listColors = [
    Colors.black,
    Colors.blue.shade900,
    Colors.grey.shade900,
    Colors.brown.shade800
  ];

  Color selectedColour(int position) {
    return listColors[position % 4];
  }

  Future loadData() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 7), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(

                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Search an anime...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      setState(() {
                        getAnime(myController.text);
                      });
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 8.5 / 15.0,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 350,
                        child: Card(
                          shadowColor: selectedColour(index),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          semanticContainer: true,
                          elevation: 10,
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: selectedColour(index),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).push(
                                  createRoute(
                                    MyHomePage(
                                      title: 'Biography of characters',
                                      id3: idd,
                                    ),
                                  ),
                                );
                              });
                            },
                            child: Column(children: [
                              FutureBuilder<Album>(
                                  future: getAnime( myController.text),
                                  builder: (context, snapshot) {
                                    print("snapshot.data");
                                    print(snapshot.data?.native);
                                    return snapshot.data != null
                                        ? Text(snapshot.data!.english)
                                        : SkeletonContainer.rounded(
                                            width: 150, height: 20);
                                  }),
                              SizedBox(
                                height: 3,
                              ),
                              FutureBuilder<Album>(
                                  future: getAnime(myController.text
                                      ),
                                  builder: (context, snapshot) {
                                    return snapshot.data != null
                                        ? Text(
                                            snapshot.data!.native,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          )
                                        : SkeletonContainer.rounded(
                                            width: 100, height: 10);
                                  }),
                              SizedBox(
                                height: 19.4,
                              ),
                              FutureBuilder<Album>(
                                  future: getAnime(myController.text),
                                  builder: (context, snapshot) {
                                    return snapshot.data != null
                                        ? Image.network(snapshot.data!.large)
                                        : SkeletonContainer.square(
                                            width: 200, height: 290);
                                  }),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
