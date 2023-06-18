import 'package:image_picker/image_picker.dart';
import 'package:my_app/app/app.locator.dart';
import 'package:my_app/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';

class ImagePickerViewModel extends BaseViewModel {
  final ApiService _apiService = locator<ApiService>();
  File? _pickedImage;

  File? get pickedImage => _pickedImage;

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _pickedImage = File(image.path);
      notifyListeners();
    } else {
      print('No image selected.');
    }
  }

  Future uploadImage() async {
    if (_pickedImage != null) {
      await _apiService.uploadImage(_pickedImage!);
      _pickedImage = null;
      notifyListeners();
    } else {
      // Handle when no image is picked
      print('No image to upload.');
    }
  }
}
