import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/flight.dart';
import '../../../shared/models/aircraft.dart';
import '../../../core/theme/app_theme.dart';

class PlaneProfileScreen extends StatefulWidget {
  final Flight flight;
  final double? userLatitude;
  final double? userLongitude;

  const PlaneProfileScreen({
    super.key,
    required this.flight,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  State<PlaneProfileScreen> createState() => _PlaneProfileScreenState();
}

class _PlaneProfileScreenState extends State<PlaneProfileScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final aircraft = AircraftDatabase.getAircraftWithFallback(
      widget.flight.aircraftType ?? '',
      'Unknown Aircraft',
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryDeepBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.flight.callsign?.trim() ?? widget.flight.icao24,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: _buildMapView(),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryDeepBlue,
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Flight info header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aircraft.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.flight.originCountry != null)
                          Text(
                            'Origin: ${widget.flight.originCountry}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Live Status Card
                  _buildSectionCard(
                    context,
                    title: '⚡ Live Status',
                    child: Column(
                      children: [
                        _buildStatusRow(
                          context,
                          label: 'Altitude',
                          value: widget.flight.altitudeInFeet != null
                              ? '${widget.flight.altitudeInFeet!.toInt()} ft'
                              : 'Unknown',
                          icon: Icons.height,
                        ),
                        const Divider(height: 24, color: Colors.white24),
                        _buildStatusRow(
                          context,
                          label: 'Speed',
                          value: widget.flight.velocityInMph != null
                              ? '${widget.flight.velocityInMph!.toInt()} mph'
                              : 'Unknown',
                          icon: Icons.speed,
                        ),
                        const Divider(height: 24, color: Colors.white24),
                        _buildStatusRow(
                          context,
                          label: 'Heading',
                          value: widget.flight.heading != null
                              ? '${widget.flight.heading!.toInt()}° ${widget.flight.headingCardinal ?? ""}'
                              : 'Unknown',
                          icon: Icons.explore,
                        ),
                        const Divider(height: 24, color: Colors.white24),
                        _buildStatusRow(
                          context,
                          label: 'Vertical Rate',
                          value: widget.flight.verticalRate != null
                              ? '${(widget.flight.verticalRate! * 196.85).toInt()} ft/min'
                              : 'Unknown',
                          icon: Icons.vertical_align_center,
                        ),
                      ],
                    ),
                  ),

                  // Aircraft Details Card
                  _buildSectionCard(
                    context,
                    title: '✈️ Aircraft Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aircraft.fullName,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (aircraft.registration != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Registration: ${aircraft.registration}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                        if (aircraft.age != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Age: ${aircraft.age} years',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Specifications
                        if (aircraft.wingspan != null ||
                            aircraft.maxRange != null ||
                            aircraft.maxPassengers != null) ...[
                          Text(
                            'Specifications',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.secondaryCyan,
                                    ),
                          ),
                          const SizedBox(height: 12),
                          if (aircraft.wingspan != null)
                            _buildSpecRow(
                              context,
                              label: 'Wingspan',
                              value: '${aircraft.wingspan} ft',
                            ),
                          if (aircraft.length != null)
                            _buildSpecRow(
                              context,
                              label: 'Length',
                              value: '${aircraft.length} ft',
                            ),
                          if (aircraft.maxRange != null)
                            _buildSpecRow(
                              context,
                              label: 'Range',
                              value: '${aircraft.maxRange} nm',
                            ),
                          if (aircraft.maxPassengers != null)
                            _buildSpecRow(
                              context,
                              label: 'Capacity',
                              value: '${aircraft.maxPassengers} passengers',
                            ),
                          if (aircraft.crewSize != null)
                            _buildSpecRow(
                              context,
                              label: 'Crew',
                              value: '${aircraft.crewSize}',
                            ),
                        ],
                      ],
                    ),
                  ),

                  // Fun Fact Card
                  if (aircraft.funFact != null)
                    _buildSectionCard(
                      context,
                      title: '💡 Did You Know?',
                      child: Text(
                        aircraft.funFact!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    if (widget.flight.latitude == null || widget.flight.longitude == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text('Location data unavailable'),
        ),
      );
    }

    final flightPosition = LatLng(
      widget.flight.latitude!,
      widget.flight.longitude!,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('aircraft'),
        position: flightPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan,
        ),
        infoWindow: InfoWindow(
          title: widget.flight.callsign ?? 'Aircraft',
          snippet: '${widget.flight.altitudeInFeet?.toInt() ?? 0} ft',
        ),
      ),
    };

    // Add user location marker if available
    if (widget.userLatitude != null && widget.userLongitude != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(widget.userLatitude!, widget.userLongitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: flightPosition,
        zoom: 10,
      ),
      markers: markers,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      style: '''
        [
          {
            "elementType": "geometry",
            "stylers": [{"color": "#1d2c4d"}]
          },
          {
            "elementType": "labels.text.fill",
            "stylers": [{"color": "#8ec3b9"}]
          },
          {
            "elementType": "labels.text.stroke",
            "stylers": [{"color": "#1a3646"}]
          }
        ]
      ''',
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceTranslucentLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.secondaryCyan.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.secondaryCyan.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.secondaryCyan, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white60,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '• $label:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondaryCyan,
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
