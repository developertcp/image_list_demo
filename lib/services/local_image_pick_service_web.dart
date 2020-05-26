// drop the split code when https://github.com/flutter/plugins/pull/2767 image_picker supports web

import 'dart:html';
import 'dart:async';

class LocalImagePickService {
  Future<File> selectImage() {
    final completer = new Completer<File>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final List<File> files = input.files;
      final reader = new FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onError.listen((error) => completer.completeError(error));
      await reader.onLoad.first;
      completer.complete(reader.result as File);
    });
    input.click();
    return completer.future;
  }
}
