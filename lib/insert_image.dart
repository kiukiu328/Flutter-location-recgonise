import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'image_recognize.dart';
import 'dart:io';

class InsertImage extends StatefulWidget {
  const InsertImage({super.key, this.title = "Sec Page"});
  final String title;

  @override
  State<InsertImage> createState() => _InsertImageState();
}

class _InsertImageState extends State<InsertImage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  void getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null && context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageRecognize(
              image: File(image.path),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Stack(alignment: Alignment.topCenter, children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SvgPicture.asset(
                'assets/images/rect.svg',
                alignment: Alignment.topCenter,
                fit: BoxFit.fill,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                getImage();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.5),
                  backgroundColor: Colors.transparent,
                  elevation: 0),
              child: const Icon(
                Icons.add_a_photo,
                size: 100,
              ),
            )
          ]),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Insert to make AI recognize',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 200,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
