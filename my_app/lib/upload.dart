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
    // var uri = Uri.parse(
    //     "https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/upload");

    // var name = "customName4." + file.path.split(".").last;
    // print(name);

    // Map<String, String> headers = {
    //   "Accept": "*/*",
    // };

    // var multipartFile = http.MultipartFile(
    //   'file',
    //   stream,
    //   length,
    // );

    // var request = http.MultipartRequest('POST', uri)
    //   ..headers.addAll(headers)
    //   ..files.add(multipartFile);

    // var res = await request.send();
    var postUri = Uri.parse(
        "https://ea9pgpvvaa.execute-api.ap-southeast-1.amazonaws.com/prod/api/user/upload");

    http.MultipartRequest request = http.MultipartRequest("POST", postUri)
      ..headers.addAll({"Accept": "*/*"});

    // ..files.add(await http.MultipartFile.fromPath('file', file.path));

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // http.MultipartFile multipartFile =
    //     await http.MultipartFile.fromPath('file', file.path);

    // request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    print(response.reasonPhrase);
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
