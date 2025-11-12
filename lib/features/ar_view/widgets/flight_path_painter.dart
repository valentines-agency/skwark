import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../shared/models/flight.dart';
import '../../../core/theme/app_theme.dart';

class FlightPathPainter extends CustomPainter {
  final List<Flight> flights;
  final double userLatitude;
  final double userLongitude;
  final double devicePitch;
  final double deviceRoll;
  final double deviceYaw;
  final Flight? selectedFlight;
  final Function(Flight) onFlightTapped;

  FlightPathPainter({
    required this.flights,
    required this.userLatitude,
    required this.userLongitude,
    required this.devicePitch,
    required this.deviceRoll,
    required this.deviceYaw,
    this.selectedFlight,
    required this.onFlightTapped,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final flight in flights) {
      if (!flight.hasValidPosition) continue;

      // Calculate if flight is in camera view
      final screenPosition = _projectFlightToScreen(
        flight,
        size,
      );

      if (screenPosition == null) continue;

      // Draw flight path
      _drawFlightPath(
        canvas,
        size,
        flight,
        screenPosition,
      );

      // Draw plane indicator
      _drawPlaneIndicator(
        canvas,
        flight,
        screenPosition,
      );
    }
  }

  Offset? _projectFlightToScreen(Flight flight, Size screenSize) {
    if (flight.latitude == null || flight.longitude == null) return null;

    // Calculate bearing and elevation to the aircraft
    final bearing = _calculateBearing(
      userLatitude,
      userLongitude,
      flight.latitude!,
      flight.longitude!,
    );

    final distance = _calculateDistance(
      userLatitude,
      userLongitude,
      flight.latitude!,
      flight.longitude!,
    );

    final elevation = _calculateElevation(
      distance,
      flight.altitude ?? 10000,
    );

    // Normalize bearing to device orientation
    // In a real AR app, we'd use ARCore/ARKit for precise tracking
    final relativeBearing = (bearing - deviceYaw) % 360;

    // Check if aircraft is in front of camera (±90 degrees)
    if (relativeBearing > 90 && relativeBearing < 270) {
      return null; // Behind the camera
    }

    // Calculate elevation relative to device pitch
    final relativeElevation = elevation - (devicePitch * 10);

    // Check if aircraft is within vertical FOV
    if (relativeElevation < -30 || relativeElevation > 30) {
      return null; // Outside vertical view
    }

    // Project to screen coordinates
    // Horizontal: 0-360 degrees maps to screen width
    // We use 90 degree FOV for horizontal
    final normalizedBearing = (relativeBearing + 360) % 360;
    final x = (normalizedBearing - 270) / 90 * screenSize.width;

    // Vertical: elevation maps to screen height
    // We use 60 degree FOV for vertical
    final y = screenSize.height / 2 - (relativeElevation / 30 * screenSize.height / 2);

    // Clamp to screen bounds with some margin
    if (x < -100 || x > screenSize.width + 100) return null;
    if (y < -100 || y > screenSize.height + 100) return null;

    return Offset(x, y);
  }

  void _drawFlightPath(
    Canvas canvas,
    Size size,
    Flight flight,
    Offset position,
  ) {
    final isSelected = selectedFlight?.icao24 == flight.icao24;

    // Create gradient paint for the path
    final gradient = LinearGradient(
      colors: isSelected
          ? [
              AppTheme.accentOrange,
              AppTheme.accentOrange.withOpacity(0.5),
            ]
          : [
              AppTheme.secondaryCyan,
              AppTheme.primaryDeepBlue.withOpacity(0.7),
            ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromPoints(
          position - const Offset(100, 0),
          position + const Offset(100, 0),
        ),
      )
      ..strokeWidth = isSelected ? 7.0 : 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Add glow effect
    if (isSelected) {
      final glowPaint = Paint()
        ..color = AppTheme.accentOrange.withOpacity(0.3)
        ..strokeWidth = 15.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawLine(
        position - const Offset(150, 0),
        position + const Offset(150, 0),
        glowPaint,
      );
    }

    // Draw the path line
    // In a real implementation, this would be a smooth curve based on
    // the aircraft's trajectory and heading
    final heading = flight.heading ?? 0;
    final headingRadians = heading * math.pi / 180;

    final pathEnd = Offset(
      position.dx + math.cos(headingRadians) * 150,
      position.dy + math.sin(headingRadians) * 150,
    );

    final path = Path();
    path.moveTo(position.dx - 150, position.dy);

    // Create curved path through the aircraft position
    final controlPoint1 = Offset(
      position.dx - 50,
      position.dy - 20,
    );
    final controlPoint2 = Offset(
      position.dx + 50,
      position.dy + 20,
    );

    path.quadraticBezierTo(
      controlPoint1.dx,
      controlPoint1.dy,
      position.dx,
      position.dy,
    );

    path.quadraticBezierTo(
      controlPoint2.dx,
      controlPoint2.dy,
      pathEnd.dx,
      pathEnd.dy,
    );

    canvas.drawPath(path, paint);

    // Draw direction arrow at the end
    _drawArrow(canvas, pathEnd, headingRadians, isSelected);
  }

  void _drawPlaneIndicator(
    Canvas canvas,
    Flight flight,
    Offset position,
  ) {
    final isSelected = selectedFlight?.icao24 == flight.icao24;

    // Draw glow for selected plane
    if (isSelected) {
      final glowPaint = Paint()
        ..color = AppTheme.accentOrange.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

      canvas.drawCircle(position, 25, glowPaint);
    }

    // Draw plane icon/indicator
    final planePaint = Paint()
      ..color = isSelected ? AppTheme.accentOrange : Colors.white
      ..style = PaintingStyle.fill;

    final planeOutlinePaint = Paint()
      ..color = isSelected ? AppTheme.accentOrange : AppTheme.secondaryCyan
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw a simple plane shape
    final planePath = Path();
    final planeSize = isSelected ? 16.0 : 12.0;

    // Rotate plane based on heading
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate((flight.heading ?? 0) * math.pi / 180);

    // Plane body
    planePath.moveTo(0, -planeSize);
    planePath.lineTo(-planeSize * 0.6, planeSize * 0.3);
    planePath.lineTo(0, planeSize * 0.6);
    planePath.lineTo(planeSize * 0.6, planeSize * 0.3);
    planePath.close();

    canvas.drawPath(planePath, planePaint);
    canvas.drawPath(planePath, planeOutlinePaint);

    canvas.restore();

    // Draw altitude and callsign label
    if (isSelected) {
      _drawFlightLabel(canvas, flight, position);
    }
  }

  void _drawFlightLabel(Canvas canvas, Flight flight, Offset position) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final callsign = flight.callsign?.trim() ?? flight.icao24;
    final altitude = flight.altitudeInFeet?.toInt().toString() ?? '---';

    final text = '$callsign\n$altitude ft';

    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        shadows: [
          Shadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            color: Colors.black,
          ),
        ],
      ),
    );

    textPainter.layout();

    // Draw background
    final labelBg = Paint()
      ..color = AppTheme.surfaceTranslucentDark
      ..style = PaintingStyle.fill;

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(position.dx, position.dy - 35),
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(bgRect, labelBg);

    // Draw text
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - 35 - textPainter.height / 2,
      ),
    );
  }

  void _drawArrow(
    Canvas canvas,
    Offset position,
    double angle,
    bool isSelected,
  ) {
    final arrowPaint = Paint()
      ..color = isSelected ? AppTheme.accentOrange : AppTheme.secondaryCyan
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);

    final arrowPath = Path();
    arrowPath.moveTo(-8, -6);
    arrowPath.lineTo(0, 0);
    arrowPath.lineTo(-8, 6);

    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();
  }

  // Calculate bearing between two points (in degrees)
  double _calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLon = (lon2 - lon1) * math.pi / 180;
    final lat1Rad = lat1 * math.pi / 180;
    final lat2Rad = lat2 * math.pi / 180;

    final y = math.sin(dLon) * math.cos(lat2Rad);
    final x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(dLon);

    final bearing = math.atan2(y, x) * 180 / math.pi;
    return (bearing + 360) % 360;
  }

  // Calculate distance between two points (in meters)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters

    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Calculate elevation angle to aircraft (in degrees)
  double _calculateElevation(double distance, double altitude) {
    if (distance == 0) return 90;
    final elevationRad = math.atan2(altitude, distance);
    return elevationRad * 180 / math.pi;
  }

  @override
  bool shouldRepaint(FlightPathPainter oldDelegate) {
    return oldDelegate.flights != flights ||
        oldDelegate.devicePitch != devicePitch ||
        oldDelegate.deviceRoll != deviceRoll ||
        oldDelegate.deviceYaw != deviceYaw ||
        oldDelegate.selectedFlight != selectedFlight;
  }

  @override
  bool hitTest(Offset position) => true;
}
