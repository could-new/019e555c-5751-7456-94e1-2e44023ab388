import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Capture Parser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CaptureScreen(),
      },
    );
  }
}

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  bool _isCapturing = false;
  Timer? _timer;
  String _latestAnalysis = "No captures yet.";
  int _captureCount = 0;

  void _toggleCapture() {
    setState(() {
      _isCapturing = !_isCapturing;
    });

    if (_isCapturing) {
      _startCaptureLoop();
    } else {
      _stopCaptureLoop();
    }
  }

  void _startCaptureLoop() {
    // Initial capture
    _performCaptureAndAnalysis();
    
    // Set up 30-second interval
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _performCaptureAndAnalysis();
    });
  }

  void _stopCaptureLoop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _performCaptureAndAnalysis() async {
    // In a real Android implementation, this is where you would call a 
    // native MethodChannel to trigger MediaProjection screen capture.
    // Since we cannot capture other apps (like Chamet) directly from pure Flutter,
    // we simulate the capture and color parsing process here.
    
    setState(() {
      _captureCount++;
      _latestAnalysis = "Processing capture $_captureCount...";
    });

    try {
      // Simulating loading a captured screenshot (using an empty image or dummy bytes)
      // In production, you would process the byte array from the native capture.
      await Future.delayed(const Duration(seconds: 1)); // Simulate processing delay
      
      // Dummy logic: Create a small test image to represent the parsed screen
      final image = img.Image(width: 100, height: 100);
      img.fill(image, color: img.ColorRgb8(255, 0, 0)); // Red 'road'
      
      // Sample parsing logic: Get color of a specific coordinate (e.g. the 'road' patti)
      final pixel = image.getPixel(50, 50);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;
      
      // Determine dominant color or specific target
      String detectedColor = "Unknown";
      if (r > g && r > b) {
        detectedColor = "Red (Likely Road Patti)";
      } else if (g > r && g > b) {
        detectedColor = "Green";
      } else if (b > r && b > g) {
        detectedColor = "Blue";
      }

      setState(() {
        _latestAnalysis = "Capture $_captureCount completed.\nDetected Color: $detectedColor\nRGB: ($r, $g, $b)";
      });
      
      // Here you would send the data to Supabase/Database
      // e.g., await Supabase.instance.client.from('captures').insert({'color': detectedColor});

    } catch (e) {
      setState(() {
        _latestAnalysis = "Error during processing: $e";
      });
    }
  }

  @override
  void dispose() {
    _stopCaptureLoop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen Analyzer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.screen_search_desktop_rounded,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 24),
            Text(
              'Background Capture Service',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Takes a screenshot every 30 seconds to parse road colors from the racing game.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Status: ${_isCapturing ? "Running" : "Stopped"}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isCapturing ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _latestAnalysis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _toggleCapture,
              icon: Icon(_isCapturing ? Icons.stop : Icons.play_arrow),
              label: Text(_isCapturing ? 'Stop Capture Service' : 'Start Capture Service'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _isCapturing ? Colors.red.shade100 : Colors.green.shade100,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
