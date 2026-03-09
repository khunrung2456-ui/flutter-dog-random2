import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DogScreen(),
    );
  }
}

class DogScreen extends StatefulWidget {
  const DogScreen({super.key});
  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
  String imageUrl = '';
  bool isLoading = false;

  Future<void> fetchDog() async {
    setState(() { isLoading = true; });
    try {
      final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrl = data['message'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() { isLoading = false; });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สุ่มรูปน้องหมา 🐶'), backgroundColor: Colors.amber),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : imageUrl.isEmpty
                ? const Text('ไม่พบรูปภาพ')
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network(imageUrl),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchDog,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.pets),
      ),
    );
  }
}