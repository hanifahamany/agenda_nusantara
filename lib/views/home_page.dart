import 'package:flutter/material.dart';
import 'package:agenda_nusantara/services/db_helper.dart';
import 'package:intl/intl.dart'; 
import 'package:agenda_nusantara/views/login_page.dart';
import 'package:agenda_nusantara/views/add_penting_page.dart';
import 'package:agenda_nusantara/views/add_biasa_page.dart'; 
import 'package:agenda_nusantara/views/daftar_tugas_page.dart';
import 'package:agenda_nusantara/views/settings_page.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _agendas = [];
  final DbHelper _dbHelper = DbHelper();
  String _username = "user"; 
  bool _startAnimate = false; 
  Timer? _timer; 
  String get _formattedUsername => _username.isNotEmpty 
    ? _username[0].toUpperCase() + _username.substring(1) 
    : "";

  @override
  void initState() {
    super.initState();
    _loadUsername(); 
    _refreshData();
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  void _refreshData() async {
    final data = await _dbHelper.getAgendas();
    
    if (mounted) {
      setState(() {
        _agendas = data;
        _startAnimate = false; 
      });

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _startAnimate = true; 
          });
        }
      });
    }
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'user';
    });
  }

  String _formatTgl(String? date) {
    if (date == null || date.isEmpty) return "-";
    DateTime dt = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(dt);
  }

  List<Widget> _generateChartBars() {
    final dataSelesai = _agendas.where((e) => e['is_completed'] == 1).toList();

    if (dataSelesai.isEmpty) {
      return [
        const Text("BELUM ADA TUGAS SEELSAI", style: TextStyle(color: Colors.grey, fontSize: 11))
      ];
    }

    Map<String, int> tugasPerHari = {};
    for (var agenda in dataSelesai) {
      if (agenda['due_date'] != null) {
        DateTime dt = DateTime.parse(agenda['due_date']);
        String tgl = DateFormat('dd/MM').format(dt);
        tugasPerHari[tgl] = (tugasPerHari[tgl] ?? 0) + 1;
      }
    }

    int maxTugas = tugasPerHari.values.reduce((a, b) => a > b ? a : b);
    if (maxTugas == 0) maxTugas = 1; 

    return tugasPerHari.entries.map((e) {
      double tinggiBar = (e.value / maxTugas) * 80; 
      return _buildBar(e.key, tinggiBar, e.value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    int selesai = _agendas.where((e) => e['is_completed'] == 1).length;
    int belumSelesai = _agendas.where((e) => e['is_completed'] == 0).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Beranda"), 
        backgroundColor: const Color(0xFF284C67),
        foregroundColor: const Color(0xFFFEBE11),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Halo, $_formattedUsername 👋", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text(DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()), style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  _buildStatCard("SELESAI", selesai.toString(), Colors.green),
                  const SizedBox(width: 10),
                  _buildStatCard("BELUM SELESAI", belumSelesai.toString(), Colors.red),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  const Text("GRAFIK TUGAS SELESAI", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _generateChartBars(),
                    ),
                  ),
                ],
              ),
            ),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              mainAxisSpacing: 10, 
              crossAxisSpacing: 10,
              childAspectRatio: 1.3, // DIUBAH DARI 2.5 KE 1.3
              children: [
                _buildMenuBtn("TAMBAH TUGAS PENTING ", 'assets/images/add-penting.png', Colors.white, () 
                                async {
                                  final refresh = await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const AddPentingPage()),
                                  );
                                  if (refresh == true) _refreshData();
                                }),
                _buildMenuBtn("TAMBAH TUGAS BIASA", 'assets/images/add-biasa.png', Colors.white, () 
                                async {
                                  final refresh = await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const AddBiasaPage()),
                                  );
                                  if (refresh == true) _refreshData();
                                }),
                _buildMenuBtn("DAFTAR TUGAS", 'assets/images/daftar-tugas.png', Colors.white, () 
                                async {
                                  final refresh = await Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const DaftarTugasPage()),
                                  );
                                  if (refresh == true) _refreshData();
                                }),
                _buildMenuBtn("PENGATURAN", 'assets/images/pengaturan.png', Colors.white, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())).then((_) => _loadUsername());
                }),
              ],
            ),

            // const Divider(height: 30),
          ],
        ),
      ),
    );
  }

  //ui helper
  Widget _buildStatCard(String title, String count, Color numColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(color: numColor, fontSize: 50, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.black87, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, double heightPercent, int jumlah) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          jumlah.toString(), 
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 5),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500), 
          curve: Curves.easeOutBack, 
          width: 25, 
          height: _startAnimate ? heightPercent : 0.0, 
          decoration: BoxDecoration(
            color: const Color(0xFF284C67), 
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildMenuBtn(String label, String imagePath, Color bgColor, VoidCallback onTap) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      padding: const EdgeInsets.symmetric(vertical: 10), 
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Image.asset(
          imagePath, 
          width: 40, 
          height: 40, 
          errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 40)
        ),
        const SizedBox(height: 8), 
        Text(
          label, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black)
        ),
      ],
    ),
  );
}
} 