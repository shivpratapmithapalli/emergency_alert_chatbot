import 'package:flutter/material.dart';
import 'chatbot_service.dart'; // Import your ChatbotService
import 'package:emergency_alert_app/location_service.dart';
import 'package:geolocator/geolocator.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final ChatbotService _chatbotService = ChatbotService();
  final LocationService _locationService = LocationService();
  Position? _currentPosition;
  bool _locationLoaded = false;
  final List<String> _messages = [];

  // Predefined message options (floating buttons)
  final List<String> _prewrittenOptions = [
    "Find me the nearest police station",
    "I need police help",
    "Am I safe here?",
    "Check my zone"
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("Location services are disabled.");
        // Optionally show a prompt to the user here
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("Location services are disabled. Please enable them.")));
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          print("Location permissions are permanently denied.");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Location permissions are permanently denied.")));
          return;
        }
      }
      Position position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _locationLoaded = true;
      });
      print(
          "Location obtained: Lat: ${position.latitude}, Lng: ${position.longitude}");
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error getting location.")));
    }
  }

  // This function sends the selected prewritten message to your backend.
  Future<void> _sendMessage(String message) async {
    if (!_locationLoaded) {
      print(
          "Location not available. Please ensure location services are enabled and try again.");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Location not available. Please enable location services and try again.")));
      return;
    }

    setState(() {
      _messages.add('You: $message');
    });

    String botResponse = "";

    switch (message) {
      case "Find me the nearest police station":
        botResponse = await _chatbotService.getResponse(
            "Find nearest police station",
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude);
        break;

      case "I need police help":
        // Open dialer or trigger emergency call logic
        // For actual calling, add permission handling for `CALL_PHONE` if needed
        await _chatbotService.callEmergency(); // You will define this
        botResponse = "Calling the police for you now...";
        break;

      case "Am I safe here?":
        botResponse = await _chatbotService.amISafeHere(
            _currentPosition!.latitude, _currentPosition!.longitude);
        break;

      case "Check my zone":
        botResponse = await _chatbotService.checkMyZone(
            _currentPosition!.latitude, _currentPosition!.longitude);
        break;

      default:
        botResponse = "Sorry, I didn't understand that.";
    }

    setState(() {
      _messages.add('Chatbot: $botResponse');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Screen'),
      ),
      body: Column(
        children: [
          // Chat messages list
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
            ),
          ),
          // Prewritten message options as floating buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _prewrittenOptions.map((option) {
                return ElevatedButton(
                  onPressed: () => _sendMessage(option),
                  child: Text(option),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
