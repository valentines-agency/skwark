# Product Requirements Document: Skwark

## 1. Overview

**Product Name:** Skwark

**Platform:** Native Flutter mobile application (iOS & Android)

**Vision:** A sleek, minimal, and modern augmented reality experience that transforms your smartphone into an intelligent aviation spotter. Point your phone at the sky and instantly see flight paths anchored to real aircraft, rendered directly in your camera view with smooth, stable AR tracking.

**Core Goal:** Deliver a seamless, on-device AR experience where users can identify multiple aircraft simultaneously, see their flight paths visualized in 3D space, and tap on any plane or path to explore detailed information. The experience should feel magical, responsive, and polished.

## 2. Target Audience

*   **Primary: The Curious Observer:** Anyone who looks up, sees a plane, and wonders, "Where is that plane going?" This user values simplicity, instant results, and a beautiful, intuitive interface.
*   **Secondary: The Aviation Enthusiast:** Plane spotters seeking detailed, accurate information with a modern, engaging presentation that goes beyond traditional tracking apps.
*   **Tertiary: Educators & Families:** A tool that makes learning about aviation immersive and interactive through cutting-edge AR technology.

## 3. Technical Architecture

### 3.1. Platform & Technology Stack

**Flutter Native Application**
*   iOS: ARKit for AR tracking and world understanding
*   Android: ARCore for AR tracking and world understanding
*   Target SDK: iOS 13+, Android 8.0+ (API 26+)

**On-Device AR Processing**
*   All AR rendering, tracking, and stabilization performed locally
*   No dependency on cloud-based AR services for core functionality
*   Real-time camera feed analysis for aircraft detection

**Flight Data Integration**
*   ADS-B data via OpenSky Network API or similar service
*   Efficient caching and background refresh (every 5-7 seconds)
*   Local spatial indexing for quick proximity queries

### 3.2. AR Rendering Architecture

**World-Space Anchoring**
*   Flight paths rendered as 3D curves in world coordinates
*   AR anchors placed at estimated aircraft positions based on:
  - GPS coordinates from ADS-B data
  - Altitude information
  - User's GPS location and device orientation
  - Camera field of view calculations

**Plane Detection & Visual Anchoring**
*   On-device computer vision to identify aircraft silhouettes in camera feed
*   When a plane is confidently detected:
  - Visual anchor point created on the actual aircraft
  - Flight path line smoothly connects to the detected plane
  - Path follows the plane as it moves across the sky
*   Confidence threshold prevents false positives
*   Graceful fallback to geometric projection when visual detection unavailable

**Stable Path Rendering**
*   Paths persist and stabilize using ARCore/ARKit motion tracking
*   Smooth interpolation between data updates
*   Predictive positioning during network delays
*   Anti-jitter algorithms for steady visualization

## 4. Core Features & Functionality

### 4.1. Live Augmented Reality View

**Clean, Minimal Interface**
*   Fullscreen camera view with no intrusive UI elements
*   **No reticle or targeting overlay** - the sky itself is the interface
*   Translucent, minimal HUD elements that don't obstruct the view
*   Material 3 design language with glass-morphism effects

**Multi-Path Visualization**
*   Display flight paths for ALL planes currently visible in camera FOV
*   Each path rendered as a smooth, curved 3D line with:
  - Gradient color coding (direction, altitude, or airline branding)
  - Subtle glow/bloom effect for visibility against any sky condition
  - Thickness that adapts to distance (closer = thicker)
  - Smooth animation of path extension as aircraft moves

**Intelligent Path-to-Plane Connection**
*   When aircraft is visible and detected in camera:
  - Path line smoothly joins to the aircraft position
  - Subtle pulsing indicator on the plane itself
  - Path updates in real-time as plane moves
*   When aircraft is not visually detected:
  - Path terminates at projected geometric position
  - Semi-transparent endpoint marker

**Dynamic Occlusion Handling**
*   Foreground objects (buildings, trees) rendered with subtle depth cues
*   Flight paths maintain visibility with intelligent depth sorting
*   Optional: translucent "scan line" effect for futuristic aesthetic

### 4.2. Interactive Plane Selection

**Natural Touch Interaction**
*   Tap directly on a visible aircraft in camera view
*   Tap on any point along a flight path
*   Both interactions select the corresponding flight

**Visual Feedback**
*   Selected path brightens and pulses subtly
*   Non-selected paths dim slightly for focus
*   Smooth color transition animation (300ms ease-out)
*   Selected aircraft gets a glowing outline overlay

**Details Panel**
*   Compact bottom sheet slides up on selection
*   Shows at-a-glance info:
  - Flight number / callsign
  - Aircraft type with icon
  - Airline with logo
  - Current altitude and speed
  - Origin → Destination
*   Smooth, physics-based animation
*   Swipe down to dismiss, tap panel to expand to full profile

### 4.3. Plane Profile View

**Immersive Detail Screen**
*   Full-screen transition with hero animation from AR view
*   Split layout:
  - Top half: Live mini AR view (optional) or aircraft photo
  - Bottom half: Scrollable information panels

**Comprehensive Data Display**
*   **Flight Information Card**
  - Real-time status (altitude, speed, heading, vertical rate)
  - Progress bar showing flight completion percentage
  - Estimated arrival time

*   **Aircraft Specifications Card**
  - Manufacturer, model, variant
  - Registration number
  - Physical specs (wingspan, length, range, capacity)
  - First flight date
  - Aircraft age

*   **Interactive Route Map**
  - 2D map showing full flight path
  - Origin and destination airports marked
  - Current aircraft position animated along path
  - User's location shown for context
  - Other nearby flights shown as faint paths

*   **Contextual Information**
  - "Did You Know?" facts about the aircraft type
  - Airline information
  - Historical flight data (optional)

**Polished UI Elements**
*   Material 3 cards with subtle elevation
*   Smooth scrolling with momentum
*   Haptic feedback on interactions
*   Skeleton loading states for async data
*   Graceful error states with retry options

### 4.4. Onboarding & Permissions

**First Launch Experience**
*   Clean, animated splash screen with Skwark branding
*   Brief 3-screen swipe tutorial explaining:
  1. "Point your phone at the sky"
  2. "See real flight paths in AR"
  3. "Tap any plane to learn more"

**Permission Flow**
*   Single screen requesting:
  - Camera (required for AR)
  - Location (required for positioning)
  - Motion sensors (automatically granted on iOS/Android)
*   Clear, benefit-focused explanation for each permission
*   "Continue to AR" button
*   Fallback instructions if permissions denied

**Calibration**
*   Brief AR initialization (1-2 seconds)
*   "Move your device to detect the environment" if needed
*   Automatic transition to main AR view when ready

## 5. User Flow

1.  **Launch:** App opens with brief splash animation
2.  **First-Time Onboarding:** Quick tutorial (skip button available)
3.  **Permissions:** Single screen to grant camera & location access
4.  **AR Initialization:** Brief calibration, then auto-transition to AR view
5.  **AR View Active:** Camera feed with multiple flight paths visible
6.  **Path Rendering:** Paths smoothly draw and stabilize in 3D space
7.  **Plane Detection:** Paths connect to visually identified aircraft
8.  **User Interaction:** User taps on a flight path or visible plane
9.  **Selection Feedback:** Path highlights, bottom sheet appears
10. **Quick Info:** User reviews basic flight info in bottom sheet
11. **Deep Dive:** User taps bottom sheet to expand to full profile
12. **Profile View:** Full-screen details with map, specs, and facts
13. **Return:** Back gesture or button returns to live AR view
14. **Continuous Tracking:** App continues to update and render paths

## 6. Design Specifications

### 6.1. Visual Design

**Color Palette**
*   Primary: Deep Blue (#1A237E) - sky, navigation
*   Secondary: Bright Cyan (#00E5FF) - active paths, highlights
*   Accent: Warm Orange (#FF6D00) - selected states, CTAs
*   Background: Dynamic (camera feed)
*   Surface: Translucent white/dark (#FFFFFF1A / #0000001A) with blur
*   Text: White with drop shadow for camera overlay

**Typography**
*   Headings: SF Pro Display (iOS) / Roboto (Android) - Bold
*   Body: SF Pro Text (iOS) / Roboto (Android) - Regular
*   Data: SF Mono (iOS) / Roboto Mono (Android) - for flight numbers

**Path Styling**
*   Default: 3pt stroke, gradient (direction-based)
*   Hover/Near: 5pt stroke, brighter gradient
*   Selected: 7pt stroke, pulsing glow, accent color
*   Material: Smooth, rounded line caps and joins

### 6.2. Animation & Motion

**Principles**
*   Smooth, natural motion (60 FPS minimum for AR)
*   Respect platform conventions (Material motion on Android, fluid on iOS)
*   Subtle, purposeful animations - never gratuitous
*   Haptic feedback on all touch interactions

**Key Animations**
*   Path drawing: Animated reveal with ease-out (500ms)
*   Selection: Color transition (300ms), scale pulse (200ms loop)
*   Bottom sheet: Physics-based slide (spring animation)
*   Screen transitions: Hero animations, shared element (400ms)
*   Loading states: Skeleton shimmer, subtle pulse

### 6.3. Performance Requirements

*   AR frame rate: 60 FPS (target), 30 FPS (minimum)
*   Touch response: < 100ms
*   Data refresh: Every 5-7 seconds (background, non-blocking)
*   App launch: < 2 seconds to AR view (warm start)
*   Battery impact: Optimized for extended use (30+ minutes)

## 7. Wireframes

### Screen 1: Welcome & Onboarding

```
+------------------------------------------+
|                                          |
|                                          |
|              ✈️ Skwark                   |
|                                          |
|       [ Animated AR preview loop ]       |
|                                          |
|        Point at the sky to see           |
|        live flight paths in AR           |
|                                          |
|                 ● ○ ○                    |
|                                          |
|          [ Continue → ]                  |
|                                          |
+------------------------------------------+
```

### Screen 2: Permissions Request

```
+------------------------------------------+
|                                          |
|    📸  Camera Access                     |
|    To see the sky and overlay flights    |
|                                          |
|    📍  Location Access                   |
|    To calculate accurate flight paths    |
|                                          |
|                                          |
|   +------------------------------------+ |
|   |      Grant Access & Start AR       | |
|   +------------------------------------+ |
|                                          |
|          Why do we need this?            |
|                                          |
+------------------------------------------+
```

### Screen 3: Live AR View (Multiple Paths)

```
+------------------------------------------+
| [ LIVE CAMERA FEED - SKY ]               |
|                                          |
|     ╱╲                                   |
|    ╱  ╲ (Plane silhouette w/ glow)       |
|   ╱────╲                                 |
|  ╱══════╲═════════════╗ (Flight path 1)  |
|                       ║                  |
|    ╭───────────────────╜                 |
|    │ (Flight path 2)                     |
|    ●─── ─── ─── ───▶                     |
|                                          |
|  ╱╲ (Building - translucent outline)     |
| ╱──╲                                     |
|╱════╲ ──────────●═══════╗ (Path 3)       |
|                          ║               |
|                                          |
| [Glass-morphic bottom overlay]           |
| 3 flights visible  👁️ AR  🔄 Tracking    |
+------------------------------------------+
```

### Screen 4: AR View (Selected Flight)

```
+------------------------------------------+
| [ LIVE CAMERA FEED ]                     |
|                                          |
|     ╱╲ ✨                                |
|    ╱  ╲ (Selected plane - highlighted)   |
|   ╱────╲                                 |
|  ╱══════╲═════════════════╗ (Bright path)|
|                           ║ (Pulsing)    |
|                                          |
|  (Other paths dimmed)                    |
|    ●─ ─ ─ ─ ─ ─ ─ ─ ─▶                  |
|                                          |
|                                          |
| ╔════════════════════════════════════╗   |
| ║  UA456 • United Airlines           ║   |
| ║  Boeing 787-9 Dreamliner           ║   |
| ║  ✈️ LAX → SFO                      ║   |
| ║  35,000 ft • 520 mph               ║   |
| ║                                    ║   |
| ║        [ Tap for Details ]         ║   |
| ╚════════════════════════════════════╝   |
+------------------------------------------+
```

### Screen 5: Plane Profile View

```
+------------------------------------------+
| 🡐                                    ︙  |
|                                          |
| Flight UA456                             |
| United Airlines                          |
|                                          |
| ┌────────────────────────────────────┐   |
| │  [ Interactive Map ]               │   |
| │   LAX ●═══════🛫══════════● SFO    │   |
| │         (Animated position)        │   |
| │   📍 You are here                  │   |
| └────────────────────────────────────┘   |
|                                          |
| ⚡ Live Status ────────────────────────   |
| Altitude:    35,000 ft ↑ 0 ft/min        |
| Speed:       520 mph                     |
| Heading:     312° NW                     |
| ETA:         14 min                      |
| [Progress: ▓▓▓▓▓▓▓▓▓▓░░░░] 68%           |
|                                          |
| ✈️ Aircraft Details ──────────────────   |
| Boeing 787-9 Dreamliner                  |
| N26952 • Age: 3 years                    |
|                                          |
| • Wingspan: 197 ft                       |
| • Range: 7,635 nm                        |
| • Capacity: 296 passengers               |
|                                          |
| 💡 Did You Know? ─────────────────────   |
| The 787's wings can flex up to 26 feet   |
| during flight, enabled by carbon fiber   |
| composite materials.                     |
|                                          |
+------------------------------------------+
```

## 8. Success Metrics

### User Engagement
*   Time in AR view per session: Target > 2 minutes
*   Flights tapped per session: Target > 3
*   Return usage rate: Target > 40% weekly

### Technical Performance
*   AR tracking stability: > 95% frame lock
*   Visual aircraft detection accuracy: > 70% when in view
*   Path-to-plane connection success: > 80% when detected
*   App crash rate: < 0.1%

### User Satisfaction
*   App Store rating: Target > 4.5 stars
*   User feedback on UX smoothness: Target > 90% positive
*   Permission grant rate: Target > 85%

## 9. Future Enhancements

*   **AR Cloud Anchors:** Persistent paths that multiple users can see
*   **Historical Playback:** See flight paths from earlier in the day
*   **Aircraft Recognition ML:** On-device model to identify aircraft types
*   **Sound Integration:** Spatial audio with aircraft engine sounds
*   **Notifications:** Alert when specific aircraft types are overhead
*   **Social Features:** Share AR screenshots with overlaid flight data
*   **Offline Mode:** Cache common aircraft data for use without internet

## 10. Development Priorities

### Phase 1: Core AR Experience (MVP)
1. Flutter app structure with ARCore/ARKit integration
2. Basic AR world tracking and stabilization
3. Flight data integration with ADS-B API
4. Multi-path rendering in AR space
5. Geometric path-to-sky projection
6. Touch interaction on paths
7. Basic details bottom sheet

### Phase 2: Visual Enhancement
1. On-device plane detection with computer vision
2. Visual anchoring of paths to detected planes
3. Polished UI with Material 3 design
4. Smooth animations and transitions
5. Profile view with interactive map
6. Performance optimization

### Phase 3: Polish & Scale
1. Advanced path stabilization algorithms
2. Battery and performance tuning
3. Error handling and edge cases
4. Comprehensive testing (different sky conditions, locations)
5. Accessibility features
6. Analytics integration

---

**Document Version:** 2.0
**Last Updated:** 2025-11-12
**Status:** Ready for Development
