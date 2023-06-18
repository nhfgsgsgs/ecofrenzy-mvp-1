import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'photo_viewmodel.dart';

class PhotoView extends StackedView<PhotoViewModel> {
  const PhotoView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PhotoViewModel viewModel,
    Widget? child,
  ) {
    return const Scaffold(
      body: Text('Photo View'),
    );
  }

  @override
  PhotoViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PhotoViewModel();
}
