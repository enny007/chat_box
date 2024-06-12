// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class ImageModel {
  final Uint8List image;
  final String mimetype;

  ImageModel({
    required this.image,
    required this.mimetype,
  });

  @override
  String toString() => 'ImageModel(image: $image, mimetype: $mimetype)';
}
