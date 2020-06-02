import 'dart:io';
import 'package:flutter/material.dart';

/// Extends FileImage:
/// Decodes the given [File] object as an image, associating it with the given
/// scale. Placeholder for failed image lookup
///
// @immutable
class HybridImage extends FileImage {
// class HybidImage extends ImageProvider<FileImage> {
  /// Creates an object that decodes a [File] as an image.
  ///
  File file;
  HybridImage(File file) : super(file) {
// print(file.path);
    final placeholder =
        File('/storage/emulated/0/app images/042-hair-dryer.png');
    this.file = file.existsSync() ? file : placeholder;
  }
}
