import 'package:flutter/material.dart';

import 'package:adv_mon/features/navigation/data/navigation_guidance_service.dart';
import 'package:adv_mon/features/navigation/data/voice_guidance_service.dart';

/// Top HUD banner displaying turn-by-turn navigation instructions,
/// distance to next maneuver, voice speaker toggle, and exit button.
class TurnByTurnBanner extends StatelessWidget {
  const TurnByTurnBanner({
    super.key,
    required this.snapshot,
    required this.voiceService,
    required this.onCancel,
  });

  final GuidanceSnapshot snapshot;
  final VoiceGuidanceService voiceService;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.isActive) return const SizedBox.shrink();

    final theme = Theme.of(context);

    // Format distance to next turn
    final distMeters = snapshot.distanceToNextTurnMeters;
    final String distText = distMeters >= 1000
        ? '${(distMeters / 1000.0).toStringAsFixed(1)} km'
        : '${distMeters.round()} m';

    return Material(
      color: snapshot.isOffRoute
          ? Colors.orange.shade900.withAlpha(240)
          : snapshot.hasArrived
              ? Colors.green.shade800.withAlpha(240)
              : Colors.black.withAlpha(230),
      borderRadius: BorderRadius.circular(20),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Direction Turn Maneuver Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      snapshot.hasArrived
                          ? Icons.check_circle
                          : snapshot.isOffRoute
                              ? Icons.sync
                              : _getTurnIcon(snapshot.modifier),
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Distance countdown and instruction
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!snapshot.hasArrived && !snapshot.isOffRoute)
                        Text(
                          distText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      Text(
                        snapshot.hasArrived
                            ? 'Arrived at Destination'
                            : snapshot.isOffRoute
                                ? 'Off Route · Recalculating...'
                                : snapshot.currentInstruction,
                        style: TextStyle(
                          fontSize: snapshot.isOffRoute ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: snapshot.isOffRoute
                              ? Colors.white
                              : Colors.white.withAlpha(220),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (snapshot.streetName != null &&
                          !snapshot.hasArrived &&
                          !snapshot.isOffRoute)
                        Text(
                          snapshot.streetName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Voice Mute Toggle
                IconButton(
                  tooltip: voiceService.isMuted ? 'Unmute Voice' : 'Mute Voice',
                  icon: Icon(
                    voiceService.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    voiceService.toggleMute();
                  },
                ),

                // Exit / Cancel Navigation
                IconButton(
                  tooltip: 'Cancel Navigation',
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: onCancel,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Route Progress Summary Bar
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${snapshot.remainingDistanceKm.toStringAsFixed(1)} km remaining · ~${snapshot.remainingDurationMinutes} min',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (snapshot.route?.isOfflineEstimated == true)
                  const Text(
                    'Offline Estimate',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTurnIcon(String modifier) {
    switch (modifier.toLowerCase()) {
      case 'left':
        return Icons.turn_left;
      case 'right':
        return Icons.turn_right;
      case 'slight left':
        return Icons.turn_slight_left;
      case 'slight right':
        return Icons.turn_slight_right;
      case 'sharp left':
        return Icons.turn_sharp_left;
      case 'sharp right':
        return Icons.turn_sharp_right;
      case 'u-turn':
        return Icons.u_turn_left;
      case 'roundabout':
      case 'rotary':
        return Icons.roundabout_left;
      default:
        return Icons.straight;
    }
  }
}
