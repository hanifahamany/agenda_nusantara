import 'package:flutter/material.dart';
import 'package:agenda_nusantara/views/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  //variabel buat toogle password
  bool _isObscure = true;

// fungsi login validasi db memori
  void _prosesLogin() async {
    final prefs = await SharedPreferences.getInstance();
    
    // default user 
    String userSah = prefs.getString('username') ?? 'user';
    String passSah = prefs.getString('password') ?? 'user';

    if (_userController.text == userSah && _passController.text == passSah) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau Password yang anda masukkan tidak valid!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/an-logo.png', 
              height: 120, 
            ),
            const SizedBox(height: 30),
            const Text("Agenda Nusantara", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Kelola tugasmu dimana saja!", 
              style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 30),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passController,
              obscureText: _isObscure, 
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF284C67),
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _prosesLogin, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF284C67), // kode hex biru
                  foregroundColor: const Color(0xFFFEBE11), // kode hex kuning
                ),
                child: const Text("MASUK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}