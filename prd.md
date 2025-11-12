# Product Requirements Document: Skwark

## 1. Overview

**Product Name:** Skwark

**Vision:** To create an intuitive and engaging augmented reality experience for aviation enthusiasts and curious observers. Skwark transforms your view of the sky into an interactive map, allowing you to identify and learn about the aircraft flying overhead in real-time.

**Core Goal:** To provide a seamless "point-and-identify" experience. The user points their phone at the sky, and the app automatically overlays flight paths and information on the live camera feed, powered by the multimodal reasoning capabilities of the Gemini API.

## 2. Target Audience

*   **Primary: The Curious Observer:** Anyone who looks up, sees a plane, and wonders, "Where is that plane going? What kind is it?" This user values simplicity, speed, and a touch of magic.
*   **Secondary: The Aviation Enthusiast:** Plane spotters and hobbyists who seek more detailed information about aircraft, flight paths, and airline operations. They appreciate accuracy and depth of data.
*   **Tertiary: Educators & Families:** A tool to make learning about aviation, geography, and technology interactive and fun.

## 3. Core Features & Functionality

### 3.1. Live Augmented Reality View
*   **Continuous Real-Time Analysis:** The app will continuously analyze the camera feed without requiring user action (e.g., a "scan" button). It will fetch and refresh flight data automatically at regular intervals (e.g., every 5-7 seconds).
*   **Flight Path Overlay:** Identified flight paths will be rendered as smooth, curved SVG lines directly onto the camera view, illustrating the plane's trajectory.
*   **"See-Through" Occlusion:** To handle foreground objects like buildings and trees, the app will render them as translucent, glowing outlines. This creates a futuristic "scanner" effect, allowing the flight paths to remain visible *over* these objects, rather than being hidden behind them.
*   **Dynamic UI:** The interface will be minimal to maximize the camera view. Information will be presented in a clean, non-intrusive bottom panel.

### 3.2. Flight Interaction & Identification
*   **At-a-Glance List:** All detected flights in the current view will be listed in a scrollable bottom panel, showing the flight number, airline, and aircraft type.
*   **Highlight on Tap:** Tapping a flight in the list (or its corresponding path in the sky) will highlight both elements, making it easy to associate the data with the visual.
*   **Drill-Down to Profile:** Tapping a highlighted flight a second time (or a dedicated "details" button) will transition the user to the detailed `Plane Profile View`.

### 3.3. Plane Profile View
*   **Comprehensive Aircraft Data:** A dedicated screen displaying detailed information about the selected aircraft, including its name, manufacturer, specifications (wingspan, speed, range, etc.), and first flight date.
*   **Engaging Content:** A "Fun Fact" section to provide an interesting, memorable piece of information about the aircraft.
*   **Interactive Flight Map:** A 2D map view showing the aircraft's entire flight path from origin to destination. It will also plot the user's current location to provide geographic context. Other nearby flights will be shown faintly on the map for reference.

### 3.4. Seamless Onboarding
*   **Permissions Gate:** A clear, welcoming initial screen that explains *why* camera and location permissions are needed (to see the sky and calculate flight paths).
*   **One-Click Access:** A single button to initiate the permission requests and, upon success, launch directly into the Live AR View.
*   **Graceful Error Handling:** If permissions are denied, the app will provide clear, helpful instructions on how to enable them manually.

## 4. User Flow

1.  **First Launch:** User opens the app and is greeted by the **Permissions Gate**.
2.  **Granting Permissions:** User taps "Grant Permissions & Start." The browser prompts for camera and location access.
3.  **Entering AR View:** Upon granting permissions, the user is taken directly to the **Live AR View**.
4.  **Live Analysis:** The camera feed is active. A subtle "Analyzing..." indicator appears at the bottom.
5.  **Detection:** After a few seconds, flight paths are drawn on the screen, and the bottom panel populates with a list of detected flights.
6.  **Interaction:** User taps a flight path. The path and its corresponding list item turn bright blue.
7.  **Drill-Down:** User taps the highlighted list item. The app smoothly transitions to the **Plane Profile View**.
8.  **Learning:** User explores the aircraft specifications, fun fact, and interactive map.
9.  **Return:** User taps the "← Back to AR View" button to seamlessly return to the live camera feed.

## 5. Wireframes

Here are text-based wireframes describing the layout and key elements of each screen.

### Screen 1: Permissions Gate
A clean, focused screen to handle user permissions.
```
+------------------------------------------+
|                                          |
|                (Target Icon)             |
|                                          |
|                  Skwark                  |
|          The augmented reality           |
|               plane spotter.             |
|                                          |
|   +------------------------------------+ |
|   |    Grant Permissions & Start       | |
|   +------------------------------------+ |
|                                          |
| <Permissions are used to see the sky...> |
+------------------------------------------+
```

### Screen 2: Live AR View (Initial & Analyzing State)
The main interface, designed to be immersive.
```
+------------------------------------------+
| [ LIVE CAMERA FEED BACKGROUND ]          |
|                                          |
|                                          |
|                                          |
|                                          |
|             (Pulsing Target)             |
|                                          |
|                                          |
|                                          |
|                                          |
|           (Spinner) Analyzing...         |
|                                          |
+------------------------------------------+
```

### Screen 3: Live AR View (Flights Detected & Highlighted)
The core experience, showing AR data and the interactive UI panel. A flight has been tapped and is now highlighted.
```
+------------------------------------------+
| [ LIVE CAMERA FEED BACKGROUND ]          |
|                                          |
|   ...--*--... (Flight Path 1)            |
|                                          |
|  \ \ \ \ \ \ \                           |
|   \ \ \ \ \ \ (Translucent Building)     |
|    \ \ \ \ \ \                           |
| =========*========== (Flight Path 2 - HI |
|                                          |
| +--------------------------------------+ |
| | Flights Detected               [ ^ ] | |
| +--------------------------------------+ |
| | [ Flight 1 Info - Normal State ]     | |
| +--------------------------------------+ |
| | [ Flight 2 Info - HIGHLIGHTED  ]     | |
| +--------------------------------------+ |
+------------------------------------------+
```

### Screen 4: Plane Profile View
The detailed information screen, rich with data.
```
+------------------------------------------+
| <- Back to AR View                       |
|                                          |
| Flight UA456 / United Airlines           |
| Boeing 787 Dreamliner                    |
| ---------------------------------------- |
|                                          |
| +--------------------------------------+ |
| | [ Interactive 2D Map of Flight Path] | |
| |                                      | |
| +--------------------------------------+ |
|                                          |
| Specifications                         |
|  - Crew: 2                             |
|  - Capacity: 242                       |
|  - Range: 7,355 nm                     |
|                                          |
| Fun Fact                               |
|  The 787's wings flex upwards by as... |
+------------------------------------------+
```

