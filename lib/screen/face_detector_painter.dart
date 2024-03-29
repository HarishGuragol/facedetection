import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

double translateX(
    double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.Rotation_270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
    case InputImageRotation.Rotation_270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.orange;

    for (final Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(
              face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );

      void paintContour(FaceContourType type) {
        final faceContour = face.getContour(type);
        if (faceContour?.positionsList != null) {
          for (Offset point in faceContour!.positionsList) {
            canvas.drawCircle(
                Offset(
                  translateX(point.dx, rotation, size, absoluteImageSize),
                  translateY(point.dy, rotation, size, absoluteImageSize),
                ),
                1,
                paint);
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);

      print("harish");
      faces.forEach((element) {
        print(element.getContour(FaceContourType.leftEye)!.positionsList);
        print(element.getContour(FaceContourType.leftCheek)!.positionsList);
        print(
            element.getContour(FaceContourType.leftEyebrowTop)!.positionsList);
        print(element
            .getContour(FaceContourType.leftEyebrowBottom)!
            .positionsList);
        print(
            element.getContour(FaceContourType.rightEyebrowTop)!.positionsList);
        print(element
            .getContour(FaceContourType.rightEyebrowBottom)!
            .positionsList);
        print(element.getContour(FaceContourType.rightEye)!.positionsList);
        print(element.getContour(FaceContourType.rightCheek)!.positionsList);
        print(element.getContour(FaceContourType.noseBridge)!.positionsList);
        print(element.getContour(FaceContourType.noseBottom)!.positionsList);
        print(element.getContour(FaceContourType.upperLipTop)!
            .positionsList);
        print(
            element.getContour(FaceContourType.upperLipBottom)!
            .positionsList);
        print(element.getContour(FaceContourType.lowerLipTop)!.positionsList);
        print(
            element.getContour(FaceContourType.lowerLipBottom)!.positionsList);
      });
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
