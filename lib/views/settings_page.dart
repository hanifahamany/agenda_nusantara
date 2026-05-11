import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userController = TextEditingController();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();

  // Variabel untuk mengontrol toggle password
  bool _isObscureCurrent = true;
  bool _isObscureNew = true;

  final Color primaryColor = const Color(0xFF284C67);
  final Color accentColor = const Color(0xFFFEBE11);

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userController.text = prefs.getString('username') ?? 'user';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String storedPass = prefs.getString('password') ?? 'user';

    if (_currentPassController.text != storedPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal! Password saat ini salah."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPassController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru tidak boleh kosong")),
      );
      return;
    }

    await prefs.setString('username', _userController.text);
    await prefs.setString('password', _newPassController.text);
    
    _currentPassController.clear();
    _newPassController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil! Pengaturan akun telah diperbarui."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: primaryColor,
        foregroundColor: accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Keamanan Akun",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF284C67)),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: "Username Baru",
                      labelStyle: TextStyle(color: primaryColor),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: _currentPassController,
                    obscureText: _isObscureCurrent, 
                    decoration: InputDecoration(
                      labelText: "Password Saat Ini",
                      hintText: "Masukkan sandi lama",
                      labelStyle: TextStyle(color: primaryColor),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureCurrent ? Icons.visibility_off : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureCurrent = !_isObscureCurrent;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: _newPassController,
                    obscureText: _isObscureNew, // Menggunakan variabel state
                    decoration: InputDecoration(
                      labelText: "Password Baru",
                      hintText: "Masukkan sandi baru",
                      labelStyle: TextStyle(color: primaryColor),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureNew ? Icons.visibility_off : Icons.visibility,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureNew = !_isObscureNew;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: accentColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("SIMPAN PERUBAHAN", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "DEVELOPER APLIKASI",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/foto-aing.JPG'), 
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: primaryColor, width: 2),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "HANIFAH",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            const SizedBox(height: 5),
                            const Text("NIM: 2241720127", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 5),
                            const Text("kicau mania", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}