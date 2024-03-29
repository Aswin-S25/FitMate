import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.absoluteImageSize, this.rotation);
  List<Color> jointColors = [
    Colors.red, // Color for the first joint
    Colors.green, // Color for the second joint
    Colors.blue, // Color for the third joint
    // ...
  ];
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.orange;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.white;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;

    final dottedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        if(landmark.type != PoseLandmarkType.leftEar && landmark.type != PoseLandmarkType.rightEar && landmark.type != PoseLandmarkType.leftEye && landmark.type != PoseLandmarkType.rightEye && landmark.type != PoseLandmarkType.leftMouth && landmark.type != PoseLandmarkType.rightMouth && landmark.type != PoseLandmarkType.nose && landmark.type != PoseLandmarkType.leftPinky && landmark.type != PoseLandmarkType.rightPinky && landmark.type != PoseLandmarkType.leftIndex && landmark.type != PoseLandmarkType.rightIndex && landmark.type != PoseLandmarkType.leftThumb && landmark.type != PoseLandmarkType.rightThumb && landmark.type != PoseLandmarkType.leftHeel && landmark.type != PoseLandmarkType.rightHeel && landmark.type != PoseLandmarkType.leftFootIndex && landmark.type != PoseLandmarkType.rightFootIndex){
          canvas.drawCircle(
              Offset(translateX(landmark.x, rotation, size, absoluteImageSize),
                  translateY(landmark.y, rotation, size, absoluteImageSize)),
              1,
              paint);
        }
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;

        final path = Path();

        path.moveTo(translateX(joint1.x, rotation, size, absoluteImageSize),
            translateY(joint1.y, rotation, size, absoluteImageSize));

        path.lineTo(translateX(joint2.x, rotation, size, absoluteImageSize),
            translateY(joint2.y, rotation, size, absoluteImageSize));

        canvas.drawPath(path, dottedPaint);
      
      }


      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);
      paintLine(
          PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, rightPaint);

      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}

