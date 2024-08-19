import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'dart:convert';
import 'map.dart';

class ImageRecognize extends StatefulWidget {
  final File image;
  const ImageRecognize({super.key, required this.image});

  @override
  _ImageRecognizeState createState() => _ImageRecognizeState();
}

class _ImageRecognizeState extends State<ImageRecognize> {
  String? _imagePrediction;
  Model? _imageModel;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<Map<String, dynamic>> loadModel() async {
    String pathImageModel = "assets/models/landmark_classifier_lite.pt";
    try {
      _imageModel = await PyTorchMobile.loadModel(pathImageModel);
      _imagePrediction = await _imageModel!.getImagePrediction(
          widget.image, 224, 224, "assets/labels/labels.csv");
    } on PlatformException {
      print("only supported for android and ios so far");
    }
    final jsonString =
        await rootBundle.loadString('assets/data/landmarks.json');
    Map<String, dynamic> data = jsonDecode(jsonString);

    return data[_imagePrediction];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: loadModel(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget image;
        String title;
        String description;
        Widget flag;
        Widget button = Container();
        if (snapshot.hasData) {
          button = TextButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(
                          lat: snapshot.data["latitude"],
                          long: snapshot.data["longitude"],
                          name: snapshot.data["name"])))
            },
            child: const Icon(
              Icons.map,
              size: 50,
            ),
          );
          image = Image.asset(
            "assets/images/${snapshot.data["id"]}.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
          );
          title = snapshot.data["name"];
          description = snapshot.data["description"];
          flag = Expanded(
              child: Image.asset(
            "assets/images/${snapshot.data["country"]}.gif",
            height: MediaQuery.of(context).size.height * 0.15,
          ));
        } else if (snapshot.hasError) {
          image = Image.asset("assets/images/Earth.png");
          flag = Image.asset("assets/images/Earth.png");
          title = "Error";
          description = "";
        } else {
          image = const CircularProgressIndicator();
          flag = const CircularProgressIndicator();
          title = "Loading...";
          description = "";
        }
        return Column(children: [
          Stack(alignment: Alignment.topRight, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(50))),
                child: image,
              ),
            ),
            button,
          ]),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(100, 179, 121, 223),
                        Colors.transparent
                      ]),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50))),
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    child: ListView(children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: flag,
                      )
                    ]),
                  )))
        ]);
      },
    ));
  }
}
