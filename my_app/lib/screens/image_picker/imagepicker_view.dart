import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'imagepicker_viewmodel.dart';

class ImagePickerView extends StatelessWidget {
  const ImagePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ImagePickerViewModel>.reactive(
      viewModelBuilder: () => ImagePickerViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Image Picker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              model.pickedImage == null
                  ? Text('No image selected.')
                  : Image.file(model.pickedImage!),
              ElevatedButton(
                onPressed: model.pickImage,
                child: Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: model.uploadImage,
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
