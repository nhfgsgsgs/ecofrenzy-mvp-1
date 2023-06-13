import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    // Create a copy of the file with a unique name in the temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempFile = await file.copy(
        '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.png');

    var stream = http.ByteStream(Stream.castFrom(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse(
        "http://192.168.54.105:3000/api/user/647f4871cba2f4670727a9a6/upload");

    var name = "customName4." + file.path.split(".").last;
    print(name);

    Map<String, String> headers = {
      "Accept": "multipart/form-data",
    };

    var multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
    );

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(multipartFile);

    var res = await request.send();

    print(res.statusCode);
    print(res.reasonPhrase);
    print(file.length());

    // Check if the copy of the file exists
    print('Temp file exists: ${await tempFile.exists()}');
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
