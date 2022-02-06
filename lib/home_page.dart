import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textEditingController = TextEditingController();

  //url leri tutacak liste
  List<String> gif = [];

  void getGifData(String word) async {
    var url = Uri.https("api.tenor.com", "/v1/search",
        {"q": word, "key": "LIVDSRZULELA", "limit": "8"});

    var locationData = await http.get(url);

    var locationDataParsed = jsonDecode(locationData.body);

    gif.clear();

    //listenin içini dolduruyoruz
    for (int i = 0; i < 8; i++) {
      gif.add(locationDataParsed['results'][i]['media'][0]['tinygif']['url']);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getGifData("batman");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Gif Ara",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  getGifData(textEditingController.text);
                  textEditingController.clear();
                  //Butona tıklanma sonrası klavyeyi kapat
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                },
                child: const Text(
                  "Ara",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.teal,
                  ),
                ),
              ),
              gif.isEmpty
                  ? const Center(
                    child: SpinKitSpinningLines(
                        color: Colors.teal,
                      ),
                  )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return GifCard(gif[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;

  GifCard(this.gifUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.network(
        gifUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
