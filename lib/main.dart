import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:agenda_nusantara/views/login_page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await initializeDateFormatting('id_ID', null); 
  runApp(const AgendaNusantaraApp());
}

class AgendaNusantaraApp extends StatelessWidget {
  const AgendaNusantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Nusantara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const LoginPage(), 
    );
  }
}