// import 'dart:async';
// import 'dart:io';
//
// import 'package:exif/exif.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flu/server_requests/utils/flu_isolate.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;
// import 'package:image/image.dart' as img;
//
// import '../../views/components/templates/ui_templates.dart';
//
// class _ImageEditData {
//   final String filePath;
//   final Directory tempDir;
//   final bool? workOnCopy;
//   final String? renameTo;
//   final bool adjustLeftRotation;
//
//   _ImageEditData(
//       {required CroppedFile file,
//         required this.tempDir,
//         this.workOnCopy,
//         this.renameTo,
//         required this.adjustLeftRotation})
//       : assert(file != null),
//         assert(tempDir != null),
//         assert(adjustLeftRotation != null),
//         filePath = file.path;
// }
//
// class FileUtils {
//   static final renameDateFormat = DateFormat("yMMdd_HHmmss");
//
//   static Future<String> _isolateCallback(_ImageEditData data, IsolateProgressCallback progressCallback) async {
//     assert(data.workOnCopy == true || data.adjustLeftRotation || data.renameTo != null,
//     "At least one between these condition must be true unless is useless to spawn a separate process to do work");
//
//     final logProgress = (int progress) => progressCallback(progress, 3);
//
//     logProgress(0);
//
//     File image = File(data.filePath);
//
//     final newFilename = data.renameTo;
//
//     //You must copy to temp if you rename or change rotation metadata
//     final copyToTemp = data.workOnCopy == true || data.adjustLeftRotation || newFilename != null;
//
//     if (copyToTemp) {
//       String newPath = path.join(data.tempDir.path, path.basename(image.path));
//
//       //Copy if not already in temp dir
//       if (image.path != newPath) {
//         image = image.copySync(newPath);
//       }
//     }
//
//     logProgress(1);
//
//     if (newFilename != null) {
//       image = await image.rename(path.join(image.parent.path, newFilename));
//     }
//
//     logProgress(2);
//
//     if (data.adjustLeftRotation) {
//       try {
//         await _fixExifRotation(image.absolute);
//       } catch (e, stack) {
//       }
//     }
//
//     logProgress(3);
//
//     return image.absolute.path;
//   }
//
//   static img.Decoder? _findDecoderForNamedData(List<int> bytes, [String? imageFilename]) {
//     assert(bytes != null);
//
//     img.Decoder? imageDecoder = img.findDecoderForData(bytes);
//
//     if (imageDecoder == null && imageFilename != null) imageDecoder = img.findDecoderForNamedImage(imageFilename); //img.findDecoderForNamedImage(imageFilename);
//
//     return imageDecoder;
//   }
//
//   static List<int> _encodeWithJpegFallback(img.Image fixedImage, [String? imageFilename]) {
//     assert(fixedImage != null);
//
//     List<int>? rotatedImageBytes;
//
//     //Try to rencode in the original file encoding format
//     if (imageFilename != null) {
//       rotatedImageBytes = img.encodeNamedImage(fixedImage, imageFilename); //img.encodeNamedImage(imageFilename, fixedImage);
//     }
//
//     ///If can't find an encoder for the original file type, use jpg with 100 quality
//     if (rotatedImageBytes == null) {
//       if (kDebugMode) {
//         print(
//             "Encoder for ${imageFilename == null ? '(No imageFilename provided)' : path.extension(imageFilename)} can't be found. Use jpg with 100% quality");
//       }
//       rotatedImageBytes = img.encodeJpg(fixedImage);
//     }
//
//     return rotatedImageBytes;
//   }
//
//   static Future<void> _fixExifRotation(File imageFile) async {
//     assert(imageFile != null);
//     final started = DateTime.now();
//     final imagePath = imageFile.absolute.path;
//     final imageFilename = path.basename(imagePath);
//     final imageExtension = path.extension(imageFilename);
//
//     print("Fixing image rotation $imageFilename");
//
//     final reportEndRotation = (String message) {
//       print("Image rotation $message $imageFilename. Duration: ${DateTime.now().difference(started)}");
//     };
//
//     final imageBytes = imageFile.readAsBytesSync();
//
//     final imageDecoder = _findDecoderForNamedData(imageBytes, imageFilename);
//
//     Map<String, dynamic> crashlyticsContext = {
//       "file_path": imagePath,
//       "file_extension": imageExtension,
//     };
//
//     if (imageDecoder == null) {
//
//       return;
//     }
//
//     crashlyticsContext['decoder'] = imageDecoder.runtimeType.toString();
//
//     // We'll use the exif package to read exif data
//     // This is map of several exif properties
//     // Let's check 'Image Orientation'
//     final exifData = await readExifFromBytes(imageBytes);
//     crashlyticsContext["exif_data"] = exifData;
//
//     final imageOrientation = exifData['Image Orientation'];
//     final orientation = imageOrientation?.printable;
//
//     if (kDebugMode) print("exifData[\"Image Orientation\"] = $orientation");
//
//     ///exif data has no information about orientation
//     if (imageOrientation == null) {
//       reportEndRotation("no need to fix orientation");
//       return;
//     }
//
//     final decodedImage = imageDecoder.decode(imageBytes);
//
//     // if (decodedImage == null) {
//     //   Crashlytics.recordError(
//     //     "An error happened while decoding image",
//     //     StackTrace.current,
//     //     context: crashlyticsContext,
//     //   );
//     //
//     //   return;
//     // }
//
//     img.Image? fixedImage;
//
//     //Overwrite with 0 rotation
//     if (fixedImage == null) fixedImage =  img.copyRotate(decodedImage!, angle: 0);
//
//     final rotatedImageBytes = _encodeWithJpegFallback(fixedImage, imageFilename);
//
//     imageFile.writeAsBytesSync(
//       rotatedImageBytes,
//       flush: true,
//     );
//
//     reportEndRotation("fixed");
//   }
//
//   static Future<CroppedFile?> pickImage(
//       {required ImageSource source,
//         bool crop = false,
//         bool acceptOnlySquare = false,
//         bool acceptOnlyJpg = false}) async {
//     assert(crop != null);
//     assert(acceptOnlySquare != null);
//     assert(acceptOnlyJpg != null);
//
//     CroppedFile? original;
//     CroppedFile? image;
//     final imagePicker = ImagePicker();
//     final sourceCamera = source == ImageSource.camera;
//
//     //Image picker always rename the picked file
//     const renameOriginalName = false; //!sourceCamera && !Platform.isIOS;
//
//     try {
//       if (sourceCamera) {
//         final picked = await (imagePicker.pickImage(
//           source: ImageSource.camera,
//           preferredCameraDevice: CameraDevice.rear,
//         ) as FutureOr<XFile?>);
//         original = image = CroppedFile(picked?.path ?? '');
//       } else {
//         original = image = await _pickFileInternal(type: FileType.image, acceptOnlyJpg: acceptOnlyJpg);
//       }
//     } catch (e) {
//       print(e);
//       UITemplates.showToast(
//         "Impossibile aprire la " + (sourceCamera ? "fotocamera" : "galleria"),
//         ToastType.Error,
//       );
//       return null;
//     }
//
//     //If image picking canceled by the user
//     if (image == null) return null;
//
//     final originalExtension = path.extension(original!.path);
//
//     bool hasBeenCropped = false;
//
//     if (crop) {
//       try {
//         image = await _cropImageFile(
//           original,
//           possibleAspectRatios: acceptOnlySquare ? [CropAspectRatioPreset.square] : null,
//           lockAspectRatio: acceptOnlySquare,
//         );
//         hasBeenCropped = true;
//       } catch (e, stack) {
//         UITemplates.showToast("Modifica dell'immagine non supportata", ToastType.Normal);
//       }
//     }
//
//     final croppedExtension = path.extension(image!.path);
//
//     //On android images are rotated of 90 degrees to the left when using image_picker
//     const needsToRotateExtensions = [".jpg", ".jpeg"];
//     final needsAdjustLeftRotation = Platform.isAndroid && needsToRotateExtensions.contains(croppedExtension);
//
//     //If cropping canceled by the user or error happened
//     if (image == null) return null;
//
//     //Rename if there are tools that change the image filename
//     final rename = hasBeenCropped || sourceCamera;
//
//     String? newFilename;
//
//     if (rename || renameOriginalName) {
//       if (renameOriginalName) {
//         //If it doesn't arrive from camera keep the original name
//         //newFilename = _renamedImageFilename(original);
//       } else {
//         //Fallback to use actual datetime to create file name. Prefixed with source of image
//         String? prefix;
//         switch (source) {
//           case ImageSource.camera:
//             prefix = "camera";
//             break;
//
//           case ImageSource.gallery:
//             prefix = "gallery";
//             break;
//         }
//
//         newFilename = _renamedImageFilename(
//           original,
//           newName: renameDateFormat.format(DateTime.now()),
//           prefix: prefix,
//         );
//       }
//     }
//
//     ///Work on temp if not cropped and needs to modify file (name or rotation metadata)
//     final copyToTemp = (needsAdjustLeftRotation || rename) && !hasBeenCropped;
//
//     try {
//       image = await _imageEditHeavyComputation(
//         image,
//         workOnCopy: copyToTemp,
//         adjustLeftRotation: needsAdjustLeftRotation,
//         renameTo: newFilename,
//       );
//       assert(image != null);
//     } on AssertionError {
//       rethrow;
//     } catch (e, stack) {
//     }
//
//     return image;
//   }
//
//   static Future<CroppedFile?> _pickFileInternal({FileType? type, bool acceptOnlyJpg = false}) async {
//     assert(acceptOnlyJpg != null);
//     final imageAcceptOnlyJpg = acceptOnlyJpg && (type == null || type == FileType.image || type == FileType.custom);
//     try {
//       final pickerResult = await FilePicker.platform.pickFiles(
//         type: imageAcceptOnlyJpg ? FileType.custom : type ?? FileType.any,
//         allowedExtensions: imageAcceptOnlyJpg ? ["jpg", "jpeg"] : null,
//         withData: false,
//         allowMultiple: false,
//       );
//
//       if (pickerResult == null) return null;
//       return CroppedFile(pickerResult.files.single.path!);
//     } on PlatformException catch (e, stack) {
//       if (e.code == 'read_external_storage_denied')
//         UITemplates.showToast('Non è stato concesso il permesso di accedere ai file', ToastType.Error);
//       return null;
//     } catch (e, stack) {
//       return null;
//     }
//   }
//
//   static Future<CroppedFile?> _cropImageFile(CroppedFile image,
//       {List<CropAspectRatioPreset>? possibleAspectRatios, bool lockAspectRatio = false}) async {
//     assert(possibleAspectRatios == null || possibleAspectRatios.isNotEmpty);
//     assert(lockAspectRatio != null);
//     CroppedFile? croppedImage;
//
//     const defaultAspectRatios = const [
//       CropAspectRatioPreset.square,
//       CropAspectRatioPreset.ratio3x2,
//       CropAspectRatioPreset.original,
//       CropAspectRatioPreset.ratio4x3,
//       CropAspectRatioPreset.ratio16x9,
//     ];
//
//     possibleAspectRatios ??= defaultAspectRatios;
//
//     bool oneAspectRatio = possibleAspectRatios.length == 1;
//     final singleAspectRatio = oneAspectRatio ? possibleAspectRatios.single : null;
//
//     croppedImage = await ImageCropper().cropImage(
//       sourcePath: image.path,
//       aspectRatioPresets: possibleAspectRatios,
//       aspectRatio: oneAspectRatio && lockAspectRatio ? _getAspectRatio(singleAspectRatio!) : null,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: '',
//           toolbarColor: Colors.green,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: possibleAspectRatios.contains(CropAspectRatioPreset.original)
//               ? CropAspectRatioPreset.original
//               : possibleAspectRatios.first,
//           lockAspectRatio: lockAspectRatio,
//         ),
//         IOSUiSettings(
//           aspectRatioPickerButtonHidden: oneAspectRatio,
//           aspectRatioLockEnabled: lockAspectRatio,
//           resetAspectRatioEnabled: false,
//         ),
//       ],
//     );
//
//     return croppedImage;
//   }
//
//   static CropAspectRatio? _getAspectRatio(CropAspectRatioPreset aspectRatioPreset) {
//     switch (aspectRatioPreset) {
//       case CropAspectRatioPreset.original:
//         return null;
//       case CropAspectRatioPreset.square:
//         return CropAspectRatio(ratioX: 1, ratioY: 1);
//       case CropAspectRatioPreset.ratio3x2:
//         return CropAspectRatio(ratioX: 3, ratioY: 2);
//       case CropAspectRatioPreset.ratio4x3:
//         return CropAspectRatio(ratioX: 4, ratioY: 3);
//       case CropAspectRatioPreset.ratio5x3:
//         return CropAspectRatio(ratioX: 5, ratioY: 3);
//       case CropAspectRatioPreset.ratio5x4:
//         return CropAspectRatio(ratioX: 5, ratioY: 4);
//       case CropAspectRatioPreset.ratio7x5:
//         return CropAspectRatio(ratioX: 7, ratioY: 7);
//       case CropAspectRatioPreset.ratio16x9:
//         return CropAspectRatio(ratioX: 16, ratioY: 9);
//     }
//
//     return null;
//   }
//   static String _renamedImageFilename(CroppedFile image, {String? newName, String? prefix, String? ext}) {
//
//     prefix = prefix != null ? prefix + "_" : "";
//
//     final baseName = newName == null || newName.isEmpty ? path.basenameWithoutExtension(image.path) : newName;
//
//     ext = ext == null || ext.isEmpty ? _imgExtension(image) : ext;
//
//     if (!ext.startsWith(".")) ext = "." + ext;
//
//     return prefix + baseName + ext;
//   }
//
//   static String _imgExtension(CroppedFile image) {
//     final originalExtension = path.extension(image.path);
//     return originalExtension == "" ? ".jpg" : originalExtension;
//   }
//
//   static final _imageEditHeavy = FluIsolate<_ImageEditData, String>("image_edit", _isolateCallback);
//
//   static Future<CroppedFile> _imageEditHeavyComputation(CroppedFile file,
//       {required bool workOnCopy, required bool adjustLeftRotation, String? renameTo}) async {
//     assert(file != null);
//     assert(workOnCopy != null);
//     assert(adjustLeftRotation != null);
//
//     //If no work has to be done on separate process, stop here
//     if (workOnCopy != true && !adjustLeftRotation && renameTo == null) return file;
//
//     final tempDir = await pathProvider.getTemporaryDirectory();
//
//     final editedFilePath = await _imageEditHeavy.compute(
//       input: _ImageEditData(
//         file: file,
//         tempDir: tempDir,
//         workOnCopy: workOnCopy,
//         adjustLeftRotation: adjustLeftRotation,
//         renameTo: renameTo,
//       ),
//     );
//
//     assert(editedFilePath != null);
//
//     return CroppedFile(editedFilePath!);
//   }
// }