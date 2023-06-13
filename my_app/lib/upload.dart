import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? _image;

  Future upload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No image selected.');
      return;
    }

    File file = File(pickedFile.path);
    print(file.path);

    var uri = Uri.parse(
        "http://192.168.54.105:3000/api/user/647f4871cba2f4670727a9a6/upload");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', file.path,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png')));

    var response = await request.send();

    print(response.statusCode);
    print(response.reasonPhrase);

    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    // print(response.reasonPhrase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Text('No image selected.') : Image.file(_image!),
            FloatingActionButton(
              onPressed: upload,
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
            ),
          ],
        ),
      ),
    );
  }
}
