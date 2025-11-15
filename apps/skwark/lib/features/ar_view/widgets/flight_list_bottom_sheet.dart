import 'package:flutter/material.dart';
import '../../../shared/models/flight.dart';
import '../../../shared/models/aircraft.dart';
import '../../../core/theme/app_theme.dart';

class FlightListBottomSheet extends StatelessWidget {
  final Flight flight;
  final VoidCallback onViewDetails;

  const FlightListBottomSheet({
    super.key,
    required this.flight,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final aircraft = AircraftDatabase.getAircraftWithFallback(
      flight.aircraftType ?? '',
      'Unknown Aircraft',
    );

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDeepBlue.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.secondaryCyan.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with flight number and airline
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: AppTheme.secondaryCyan,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.callsign?.trim() ?? flight.icao24,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            aircraft.fullName,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white70,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Flight stats grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.height,
                        label: 'Altitude',
                        value: flight.altitudeInFeet != null
                            ? '${flight.altitudeInFeet!.toInt()}'
                            : '---',
                        unit: 'ft',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.speed,
                        label: 'Speed',
                        value: flight.velocityInMph != null
                            ? '${flight.velocityInMph!.toInt()}'
                            : '---',
                        unit: 'mph',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.explore,
                        label: 'Heading',
                        value: flight.heading != null
                            ? '${flight.heading!.toInt()}°'
                            : '---',
                        unit: flight.headingCardinal ?? '',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.vertical_align_center,
                        label: 'Vertical Rate',
                        value: flight.verticalRate != null
                            ? '${(flight.verticalRate! * 196.85).toInt()}'
                            : '---',
                        unit: 'ft/min',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Route info (if available)
                if (flight.origin != null || flight.destination != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceTranslucentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white60,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.origin ?? 'Unknown',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppTheme.secondaryCyan,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'To',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white60,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.destination ?? 'Unknown',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // View details button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    child: const Text('View Full Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceTranslucentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.secondaryCyan.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.secondaryCyan,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white60,
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
