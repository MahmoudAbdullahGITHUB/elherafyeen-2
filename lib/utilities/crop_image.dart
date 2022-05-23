import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';

import 'colors.dart';

Future<File> CropImageMethod({File image}) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: HColors.colorPrimaryDark,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  if (croppedFile != null) {
    croppedFile = await CompressAndGetFile(croppedFile, image.path);
    return croppedFile;
  }
}

// 2. compress file and get file.
Future<File> CompressAndGetFile(File file1, String file2) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file1.path,
    "$file2",
    quality: 100,
    minWidth: 700,
    minHeight: 700,
  );
  print("Elherafyeen image decreased scuccfully");
  print(result.lengthSync());

  return result;
}
