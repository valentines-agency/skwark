import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../ar_view/screens/ar_view_screen.dart';
import '../../../core/theme/app_theme.dart';

class PermissionsGateScreen extends StatefulWidget {
  const PermissionsGateScreen({super.key});

  @override
  State<PermissionsGateScreen> createState() => _PermissionsGateScreenState();
}

class _PermissionsGateScreenState extends State<PermissionsGateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkExistingPermissions();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  Future<void> _checkExistingPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final locationStatus = await Permission.location.status;

    if (cameraStatus.isGranted && locationStatus.isGranted) {
      // Permissions already granted, navigate to AR view
      if (mounted) {
        _navigateToARView();
      }
    }
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Camera access is required to see the sky and overlay flight paths.';
        });
        return;
      }

      // Request location permission
      final locationStatus = await Permission.location.request();
      if (!locationStatus.isGranted) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Location access is required to calculate accurate flight paths.';
        });
        return;
      }

      // Both permissions granted, navigate to AR view
      _navigateToARView();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error requesting permissions: $e';
      });
    }
  }

  void _navigateToARView() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ARViewScreen(),
      ),
    );
  }

  void _openAppSettings() async {
    await openAppSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDeepBlue,
              AppTheme.primaryDeepBlue.withOpacity(0.8),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // App Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondaryCyan.withOpacity(0.2),
                        border: Border.all(
                          color: AppTheme.secondaryCyan,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.airplanemode_active,
                        size: 60,
                        color: AppTheme.secondaryCyan,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      'Skwark',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                    const SizedBox(height: 16),

                    // Tagline
                    Text(
                      'The augmented reality\nplane spotter.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.normal,
                          ),
                    ),

                    const Spacer(flex: 2),

                    // Permission explanations
                    _buildPermissionItem(
                      icon: Icons.camera_alt,
                      title: 'Camera Access',
                      description: 'To see the sky and overlay flight paths',
                    ),

                    const SizedBox(height: 24),

                    _buildPermissionItem(
                      icon: Icons.location_on,
                      title: 'Location Access',
                      description: 'To calculate accurate flight positions',
                    ),

                    const Spacer(flex: 1),

                    // Error message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.red[200]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _openAppSettings,
                        child: const Text('Open Settings'),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Main CTA Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _requestPermissions,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text('Grant Access & Start AR'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Help text
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildPermissionDialog(),
                        );
                      },
                      child: Text(
                        'Why do we need this?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.secondaryCyan,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),

                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceTranslucentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.secondaryCyan, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDialog() {
    return AlertDialog(
      backgroundColor: AppTheme.primaryDeepBlue,
      title: const Text('About Permissions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skwark uses augmented reality to overlay flight information directly on your camera view.',
          ),
          const SizedBox(height: 16),
          const Text(
            'Camera: Required to show the sky and render flight paths in real-time.',
          ),
          const SizedBox(height: 12),
          const Text(
            'Location: Required to determine which flights are visible from your position.',
          ),
          const SizedBox(height: 16),
          Text(
            'Your privacy is important. We only use these permissions while the app is active.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
