import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/navigation_models.dart';

/// Interactive motorcycle location marker with heading pointer and GPS accuracy ring.
class MotorcycleLocationMarker {
  static List<Widget> buildLayers({
    required BuildContext context,
    required MotorcycleGpsPosition? position,
    bool showAccuracyCircle = true,
  }) {
    if (position == null) return const [];

    final theme = Theme.of(context);
    final headingRad = (position.heading * math.pi) / 180.0;

    return [
      // Accuracy radius circle (shows GPS precision zone in meters)
      if (showAccuracyCircle && position.accuracyMeters > 0)
        CircleLayer(
          circles: [
            CircleMarker(
              point: position.latLng,
              radius: math.min(position.accuracyMeters, 45.0),
              useRadiusInMeter: true,
              color: Colors.blueAccent.withAlpha(35),
              borderColor: Colors.blueAccent.withAlpha(120),
              borderStrokeWidth: 1.5,
            ),
          ],
        ),

      // Directional Motorcycle Marker
      MarkerLayer(
        markers: [
          Marker(
            point: position.latLng,
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Directional Heading Indicator (rotates with motorcycle bearing)
                Transform.rotate(
                  angle: headingRad,
                  child: CustomPaint(
                    size: const Size(46, 46),
                    painter: _MotorcycleHeadingPointerPainter(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                // Center Core (Honda ADV Red / White Core)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.two_wheeler,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }
}

/// Custom painter for the forward-facing navigation cone / arrow.
class _MotorcycleHeadingPointerPainter extends CustomPainter {
  const _MotorcycleHeadingPointerPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(200)
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    const topY = 2.0;

    // Forward pointing arrow beak
    path.moveTo(centerX, topY);
    path.lineTo(centerX - 8, topY + 12);
    path.lineTo(centerX, topY + 8);
    path.lineTo(centerX + 8, topY + 12);
    path.close();

    canvas.drawPath(path, paint);

    // Subtle forward beam glow
    final beamPaint = Paint()
      ..shader = RadialGradient(
        colors: [color.withAlpha(90), color.withAlpha(0)],
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, topY), radius: 18));

    final beamPath = Path();
    beamPath.moveTo(centerX, topY + 6);
    beamPath.lineTo(centerX - 14, topY - 8);
    beamPath.lineTo(centerX + 14, topY - 8);
    beamPath.close();

    canvas.drawPath(beamPath, beamPaint);
  }

  @override
  bool shouldRepaint(covariant _MotorcycleHeadingPointerPainter oldDelegate) =>
      oldDelegate.color != color;
}
