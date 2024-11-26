import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerGreen(String imageUrl,
    {double size = 160}) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final canvasSize = Size(size, size);

  final double outerCircleRadius = size / 2;
  final double innerCircleRadius = outerCircleRadius * 0.9;
  final double imageRadius = innerCircleRadius * 0.8;

  final Offset center = Offset(canvasSize.width / 2, canvasSize.height / 2);

  final paint = Paint()..color = Colors.green;
  canvas.drawCircle(center, outerCircleRadius, paint);

  final whitePaint = Paint()..color = Colors.white;
  canvas.drawCircle(center, innerCircleRadius, whitePaint);

  final profileImage = NetworkImage(imageUrl);
  final imageStream = profileImage.resolve(const ImageConfiguration());
  final completer = Completer<ImageInfo>();
  imageStream.addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
  }));
  final imageInfo = await completer.future;

  final srcRect = Rect.fromLTWH(0, 0, imageInfo.image.width.toDouble(),
      imageInfo.image.height.toDouble());
  final dstRect = Rect.fromCircle(center: center, radius: imageRadius);

  canvas.clipPath(
    Path()..addOval(Rect.fromCircle(center: center, radius: imageRadius)),
  );

  canvas.drawImageRect(imageInfo.image, srcRect, dstRect, Paint());

  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(bytes);
}
