import 'package:flutter/material.dart';
import 'package:agenda_nusantara/services/db_helper.dart';
import 'package:intl/intl.dart'; 

class DaftarTugasPage extends StatefulWidget {
  const DaftarTugasPage({super.key});

  @override
  State<DaftarTugasPage> createState() => _DaftarTugasPageState();
}

class _DaftarTugasPageState extends State<DaftarTugasPage> {
  final DbHelper _dbHelper = DbHelper();
  List<Map<String, dynamic>> _allAgendas = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await _dbHelper.getAgendas();
    setState(() {
      _allAgendas = data;
    });
  }

  String _formatTgl(String? date) {
    if (date == null || date.isEmpty) return "-";
    DateTime dt = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Daftar Tugas"),
        backgroundColor: const Color(0xFF284C67),
        foregroundColor: const Color(0xFFFEBE11),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); 
          },
        ),
      ),
      body: _allAgendas.isEmpty
          ? const Center(child: Text("Belum ada tugas dalam daftar."))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _allAgendas.length,
              itemBuilder: (context, index) {
                final item = _allAgendas[index];
                bool isPenting = item['is_important'] == 1;
                bool isSelesai = item['is_completed'] == 1;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: ListTile(
                    onTap: () async {
                      await _dbHelper.toggleComplete(item['id'], isSelesai ? 0 : 1);
                      _refreshData();
                    },
                    leading: Checkbox(
                      activeColor: const Color(0xFF284C67),
                      value: isSelesai,
                      onChanged: (val) async {
                        await _dbHelper.toggleComplete(item['id'], val! ? 1 : 0);
                        _refreshData();
                      },
                    ),
                    title: Text(
                      item['judul'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isSelesai ? TextDecoration.lineThrough : null,
                        color: isSelesai ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Text("Jatuh Tempo: ${_formatTgl(item['due_date'])}"),
                    trailing: Image.asset(
                      isPenting
                          ? 'assets/images/penting-flag.png' 
                          : 'assets/images/biasa-flag.png',  
                      height: 28, 
                      width: 28,
                      fit: BoxFit.contain,
                      // Opsional: Beri sedikit transparansi jika tugas sudah selesai
                      color: isSelesai ? Colors.white.withOpacity(0.5) : null,
                      colorBlendMode: isSelesai ? BlendMode.dstIn : null,
                    ),
                  ),
                );
              },
            ),
    );
  }
}