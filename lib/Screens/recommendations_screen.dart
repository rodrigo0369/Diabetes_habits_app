import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import '../utils/recommendations_data.dart';
import '../services/storage_service.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String _selectedDiabetesType = 'Tipo 2';
  String _selectedCountry = 'Argentina';
  List<Recommendation> _filteredRecommendations = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _filterRecommendations();
  }

  Future<void> _loadPreferences() async {
    _selectedDiabetesType = StorageService.getDiabetesType() ?? 'Tipo 2';
    _selectedCountry = StorageService.getCountry() ?? 'Argentina';
  }

  void _filterRecommendations() {
    setState(() {
      _filteredRecommendations = recommendationsData
          .map((data) => Recommendation.fromJson(data))
          .toList()
          .where((recommendation) =>
              recommendation.diabetesType == _selectedDiabetesType &&
              recommendation.country == _selectedCountry)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recomendaciones'),
      ),
      body: _filteredRecommendations.isEmpty
          ? Center(child: Text('No hay recomendaciones disponibles.'))
          : ListView.builder(
              itemCount: _filteredRecommendations.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_filteredRecommendations[index].content),
                  ),
                );
              },
            ),
    );
  }
}
