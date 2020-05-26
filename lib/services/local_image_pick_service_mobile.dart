// drop the split code when https://github.com/flutter/plugins/pull/2767 image_picker supports web

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LocalImagePickService {
  Future<File> selectImage([source]) async {
    ImageSource imageSource =
        source == 'camera' ? ImageSource.camera : ImageSource.gallery;
    // ImageSource imageSource;
    // if (source == 'camera') {
    //   imageSource = ImageSource.camera;
    // } else if (source == 'gallery') {
    //   imageSource = ImageSource.gallery;
    // }
    return await ImagePicker.pickImage(source: imageSource);
  }

  // void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
  //   if (_controller != null) {
  //     await _controller.setVolume(0.0);
  //   }
  //   if (isVideo) {
  //     final File file = await ImagePicker.pickVideo(
  //         source: source, maxDuration: const Duration(seconds: 10));
  //     await _playVideo(file);
  //   } else {
  //     await _displayPickImageDialog(context,
  //         (double maxWidth, double maxHeight, int quality) async {
  //       try {
  //         _imageFile = await ImagePicker.pickImage(
  //             source: source,
  //             maxWidth: maxWidth,
  //             maxHeight: maxHeight,
  //             imageQuality: quality);
  //         setState(() {});
  //       } catch (e) {
  //         _pickImageError = e;
  //       }
  //     });
  //   }
  // }

  // // @override
  // Future<int> getCounterValue() async {
  //   return 11;
  // }

  // // @override
  // Future<void> saveCounterValue(int value) async {
  //   // do nothing
  // }
}
