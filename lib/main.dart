import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naruto_bio/character_page.dart';
import 'package:naruto_bio/naruto_page.dart';
import 'package:http/http.dart' as http;
import 'package:naruto_bio/skeleton_container.dart';
import 'dart:async';
import 'dart:convert';
import 'anime_page.dart';
List loadedCharacters = [];
var listColors = [
  Colors.black,
  Colors.blue.shade900,
  Colors.grey.shade900,
  Colors.brown.shade800
];
Future getCharacter(int id, type) async {
  var currentIndex =
  loadedCharacters.indexWhere((currentItem) => currentItem[id] != null);
  if (currentIndex != -1) {
    return loadedCharacters[currentIndex][id][type];
  }
  var headers = {
    'Content-Type': 'application/json',
    'Cookie': 'laravel_session=V1M9t05VmT6QnSngN5OxJTzN7NjdsBo0pXWiR7sh',
    'Charset': 'utf-8',
  };
  var request =
  http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
  request.body =
  '''{"query":"{\\r\\nCharacter(id: $id){\\r\\n\\tname {\\r\\n\\t  first\\r\\n\\t  last\\r\\n\\t  full\\r\\n\\t  native\\r\\n\\t} \\r\\n  gender\\r\\n  image {\\r\\n    large\\r\\n  }\\r\\n  dateOfBirth {\\r\\n    month\\r\\n    day\\r\\n  }\\r\\n  age\\r\\n  description\\r\\n  }\\r\\n \\r\\n\\r\\n}","variables":{}}''';
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    String data = await response.stream.bytesToString();
    var characterData = jsonDecode(data)['data']['Character'];
    loadedCharacters.add({
      id: {
        'name': characterData['name']['full'],
        'image': characterData['image']['large'] == "null"
            ? null
            : characterData['image']['large'],
        'native': characterData['name']['native'],
      }
    });
    var currentCharacter = loadedCharacters
        .where((currentItem) => currentItem[id] != null)
        .toList();
    return currentCharacter[0][id][type];
  } else {
    throw Exception('Failed to load album');
  }
}
Color selectedColour(int position) {
  return listColors[position % 4];
}
List<Characters> characters = [];
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/naruto': (context) => NarutoPage(),
      },
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: AnimePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int id3;
  MyHomePage({Key? key, required this.title,required this.id3}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Future<List<Characters>> getAnimeCharacters(int counter,int id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'laravel_session=MClgA0ry25729CJBAwPbYAZMKHzO4xl4SbnK0Ca4'
    };
    var request =
        http.Request('POST', Uri.parse('https://graphql.anilist.co/'));
    request.body =
        '''{"query":"{\\r\\n  Media(id: $id, type:ANIME){\\r\\n\\r\\n    title {\\r\\n      romaji\\r\\n      english\\r\\n      native\\r\\n      userPreferred\\r\\n    }\\r\\n    characters(page:$counter){\\r\\n      nodes {\\r\\n        id\\r\\n      }\\r\\n      pageInfo {\\r\\n        total\\r\\n        perPage\\r\\n        currentPage\\r\\n        lastPage\\r\\n        hasNextPage\\r\\n      }\\r\\n\\r\\n    }\\r\\n    \\r\\n  }\\r\\n}","variables":{}}''';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var responseString = await response.stream.bytesToString();
    List<Characters> character = [];
    if (response.statusCode == 200) {
      var characters =
          json.decode(responseString)["data"]["Media"]["characters"]["nodes"];
      for (var noteJson in characters) {
        character.add(Characters.fromJson(noteJson));
      }
      return character;
    } else {
      throw ("some arbitrary error");
    }
  }

  bool loading = true;
  Future loadData()async{
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 5),( ){
    setState(() {
      loading = false;
    });
    });
  }

  @override
  void initState() {
    characters = [];
    getAnimeCharacters(counter,widget.id3).then((value) {
      setState(() {
        characters.addAll(value);
      });
    });
    loadData();
    super.initState();
  }
  int counter = 1;
  void updateCounter() {
    setState(() {
      if (counter <= 12) {
        counter++;
      }
    });
  }
  void nextPageCharacters() {
    getAnimeCharacters(counter,widget.id3).then((value) {
      setState(() {
        characters.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              setState(() {
                updateCounter();
                nextPageCharacters();
              });
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Developers Favourite Character'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              CharacterPage(
                                id2: 2910,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text('Uchiha Obito'),
                          ),
                        ),
                      ),
                    ), Container(
                      height: 50,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              CharacterPage(
                                id2: 3180,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text('Pain'),
                          ),
                        ),
                      ),
                    ), Container(
                      height: 50,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              CharacterPage(
                                id2: 14,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text('Uchiha Itachi'),
                          ),
                        ),
                      ),
                    ), Container(
                      height: 50,
                      width: 130,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              CharacterPage(
                                id2: 2910,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text('Uchiha Obito'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return  buildResults(index, context);
                },
                itemCount: characters.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 8.5 / 15.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget buildResults(int index,BuildContext context) {
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
          Navigator.of(context).push(
            createRoute(
              CharacterPage(
                id2: characters[index].id,
              ),
            ),
          );
        },
        splashColor: Colors.red,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future:
              getCharacter(characters[index].id, 'name'),
              builder: (context, snapshot) {
                return snapshot.data != null? Text(
                  snapshot.data.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ): SkeletonContainer.rounded(width: 120, height: 20);
              },
            ),
            SizedBox(height: 5,),
            FutureBuilder(
                future: getCharacter(
                    characters[index].id, 'native'),
                builder: (context, snapshot) {
                  return snapshot.data!= null ? Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                        fontSize: 10, color: Colors.grey),
                  ): SkeletonContainer.rounded(width: 80, height: 10);
                }),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder(
                future: getCharacter(
                    characters[index].id, 'image'),
                builder: (context, snapshot) {
                  return snapshot.data != null ? ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(snapshot.data.toString())) : SkeletonContainer.square(width: 200, height: 250);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



Route createRoute(Widget nameOfPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nameOfPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Characters {
  late final int id;

  Characters(
    this.id,
  );

  Characters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}
