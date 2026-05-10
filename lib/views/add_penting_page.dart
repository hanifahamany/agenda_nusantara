import 'package:flutter/material.dart';
import 'package:agenda_nusantara/services/db_helper.dart';
import 'package:intl/intl.dart';

class AddPentingPage extends StatefulWidget {
  const AddPentingPage({super.key});

  @override
  State<AddPentingPage> createState() => _AddPentingPageState();
}

class _AddPentingPageState extends State<AddPentingPage> {
  final _judulController = TextEditingController();
  final _ketController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final DbHelper _dbHelper = DbHelper();

  void _simpan() async {
    if (_judulController.text.trim().isEmpty) return;

    final data = {
      'judul': _judulController.text,
      'keterangan': _ketController.text,
      'tanggal': DateTime.now().toString(),
      'due_date': _selectedDate.toString(),
      'is_completed': 0,
      'is_important': 1,
    };

    await _dbHelper.insertAgenda(data);
    
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Tambah Tugas Penting"),
        backgroundColor: const Color(0xFF284C67),
        foregroundColor: const Color(0xFFFEBE11),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: const Color(0xFFFF0000).withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                    color: const Color(0xFFFF0000),
                    width: 1.5,
                    ),
                ),
                child: const Text(
                    "Detail Tugas Penting",
                    style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFFFF0000),
                    ),
                ),
             ),
              const SizedBox(height: 15),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Jatuh Tempo: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF284C67)),
                ),
                trailing: const Icon(Icons.calendar_month, color: Color(0xFF284C67)),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Tugas Penting",
                  labelStyle: TextStyle(color: Color(0xFF284C67)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF284C67))),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ketController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Keterangan",
                  labelStyle: TextStyle(color: Color(0xFF284C67)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF284C67))),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF284C67),
                    foregroundColor: const Color(0xFFFEBE11),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Simpan Tugas Penting", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}