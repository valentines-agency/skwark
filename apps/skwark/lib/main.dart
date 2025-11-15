import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/permissions_gate_screen.dart';
import 'shared/services/flight_data_service.dart';
import 'shared/services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SkwarkApp());
}

class SkwarkApp extends StatelessWidget {
  const SkwarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FlightDataService>(
          create: (context) => FlightDataService(),
        ),
        RepositoryProvider<LocationService>(
          create: (context) => LocationService(),
        ),
      ],
      child: MaterialApp(
        title: 'Skwark',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // AR works best in dark mode
        home: const PermissionsGateScreen(),
      ),
    );
  }
}
