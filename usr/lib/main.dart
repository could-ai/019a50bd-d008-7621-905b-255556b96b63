import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aviator Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        primaryColor: const Color(0xFFE94560),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFFE94560),
          secondary: const Color(0xFF16213E),
          surface: const Color(0xFF1F2947),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2947),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1F2947),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE94560),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ),
      home: const PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  double _predictedMultiplier = 1.0;
  final List<double> _history = [];
  bool _isPredicting = false;
  Timer? _timer;
  final Random _random = Random();

  void _togglePrediction() {
    setState(() {
      _isPredicting = !_isPredicting;
      if (_isPredicting) {
        _startPrediction();
      } else {
        _stopPrediction();
      }
    });
  }

  void _startPrediction() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _generatePrediction();
    });
  }

  void _stopPrediction() {
    _timer?.cancel();
  }

  void _generatePrediction() {
    setState(() {
      if (_history.isNotEmpty) {
        // Add the last prediction to history before generating a new one
      }
      final newPrediction = 1.0 + _random.nextDouble() * 4.0;
      _predictedMultiplier = newPrediction;
      _history.insert(0, newPrediction);
      if (_history.length > 10) {
        _history.removeLast();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aviator Predictor', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPredictionCard(),
            const SizedBox(height: 20),
            _buildHistoryList(),
            const Spacer(),
            ElevatedButton(
              onPressed: _togglePrediction,
              child: Text(_isPredicting ? 'Stop Prediction' : 'Start Prediction'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              'NEXT PREDICTED OUTCOME',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${_predictedMultiplier.toStringAsFixed(2)}x',
              style: TextStyle(
                color: _predictedMultiplier < 2.0 ? Colors.redAccent : Colors.greenAccent,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isPredicting ? 'Listening for next round...' : 'Prediction stopped',
              style: TextStyle(
                color: _isPredicting ? Colors.greenAccent : Colors.redAccent,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Predictions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _history.isEmpty
                ? const Center(
                    child: Text('No predictions yet. Start the predictor!'),
                  )
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        color: Theme.of(context).colorScheme.secondary,
                        child: ListTile(
                          leading: Icon(
                            Icons.trending_up,
                            color: item < 2.0 ? Colors.redAccent : Colors.greenAccent,
                          ),
                          title: Text(
                            '${item.toStringAsFixed(2)}x',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Text(
                            '#${_history.length - index}',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
