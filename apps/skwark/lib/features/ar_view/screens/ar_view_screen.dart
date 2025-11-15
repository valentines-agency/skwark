import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../shared/models/flight.dart';
import '../../../shared/services/flight_data_service.dart';
import '../../../shared/services/location_service.dart';
import '../widgets/flight_path_painter.dart';
import '../widgets/flight_list_bottom_sheet.dart';
import '../../plane_profile/screens/plane_profile_screen.dart';
import '../../../core/theme/app_theme.dart';

class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Location and flight data
  double? _userLatitude;
  double? _userLongitude;
  List<Flight> _flights = [];
  Flight? _selectedFlight;

  // Sensors
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _devicePitch = 0;
  double _deviceRoll = 0;
  double _deviceYaw = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeCamera();
    await _initializeLocation();
    _initializeSensors();
    _startFlightDataRefresh();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available';
          _isLoading = false;
        });
        return;
      }

      // Use back camera for AR
      final backCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      // Lock to landscape for better AR experience
      await _cameraController!.lockCaptureOrientation();

      setState(() {
        _isCameraInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize camera: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _initializeLocation() async {
    try {
      final locationService = context.read<LocationService>();
      final position = await locationService.getCurrentPosition();

      if (position != null) {
        setState(() {
          _userLatitude = position.latitude;
          _userLongitude = position.longitude;
        });
      } else {
        setState(() {
          _errorMessage = 'Unable to get location';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Location error: $e';
      });
    }
  }

  void _initializeSensors() {
    // Accelerometer for device orientation
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _devicePitch = event.x;
        _deviceRoll = event.y;
      });
    });

    // Gyroscope for rotation tracking
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      setState(() {
        _deviceYaw += event.z * 0.01; // Integrate angular velocity
      });
    });
  }

  void _startFlightDataRefresh() {
    if (_userLatitude == null || _userLongitude == null) return;

    final flightService = context.read<FlightDataService>();
    flightService.startAutoRefresh(
      latitude: _userLatitude!,
      longitude: _userLongitude!,
      onUpdate: (flights) {
        if (mounted) {
          setState(() {
            _flights = flights;
          });
        }
      },
      radiusKm: 100.0,
    );
  }

  void _onFlightTapped(Flight flight) {
    setState(() {
      _selectedFlight = flight;
    });

    // Show bottom sheet with flight details
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlightListBottomSheet(
        flight: flight,
        onViewDetails: () {
          Navigator.pop(context);
          _navigateToPlaneProfile(flight);
        },
      ),
    );
  }

  void _navigateToPlaneProfile(Flight flight) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaneProfileScreen(
          flight: flight,
          userLatitude: _userLatitude,
          userLongitude: _userLongitude,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    context.read<FlightDataService>().stopAutoRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera preview
          if (_isCameraInitialized && _cameraController != null)
            SizedBox.expand(
              child: CameraPreview(_cameraController!),
            )
          else if (_isLoading)
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.secondaryCyan,
                ),
              ),
            )
          else if (_errorMessage != null)
            Container(
              color: Colors.black,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // AR overlay with flight paths
          if (_isCameraInitialized && _userLatitude != null)
            CustomPaint(
              size: Size.infinite,
              painter: FlightPathPainter(
                flights: _flights,
                userLatitude: _userLatitude!,
                userLongitude: _userLongitude!,
                devicePitch: _devicePitch,
                deviceRoll: _deviceRoll,
                deviceYaw: _deviceYaw,
                selectedFlight: _selectedFlight,
                onFlightTapped: _onFlightTapped,
              ),
            ),

          // Top status bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Flight count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceTranslucentDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.secondaryCyan.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.airplanemode_active,
                            size: 16,
                            color: AppTheme.secondaryCyan,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_flights.length} visible',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.secondaryCyan,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // AR tracking indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceTranslucentDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.secondaryCyan.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.secondaryCyan,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Tracking',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.secondaryCyan,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading indicator when analyzing
          if (_flights.isEmpty && _userLatitude != null)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceTranslucentDark,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.secondaryCyan.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.secondaryCyan,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Scanning sky...',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.secondaryCyan,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
