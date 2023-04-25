import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

imgPicker(ImageSource source) async {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackbar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
