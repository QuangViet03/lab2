import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Máy Tính",
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _manHinh = "0";
  String _phuongTrinh = "";
  double _soThuNhat = 0;
  double _soThuHai = 0;
  String _phepTinh = "";
  bool _choSoTiepTheo = false;

  // =============================
  // NHẬP SỐ
  // =============================
  void _nhanSo(String so) {
    setState(() {
      if (_manHinh == "0" || _choSoTiepTheo) {
        _manHinh = so;
        _choSoTiepTheo = false;
      } else {
        _manHinh += so;
      }
    });
  }

  // =============================
  // XÓA KÝ TỰ CUỐI (CE)
  // =============================
  void _xoaKyTuCuoi() {
    setState(() {
      if (_manHinh.length > 1) {
        _manHinh = _manHinh.substring(0, _manHinh.length - 1);
      } else {
        _manHinh = "0";
      }
    });
  }

  // =============================
  // XÓA TẤT CẢ (C)
  // =============================
  void _xoaTatCa() {
    setState(() {
      _manHinh = "0";
      _phuongTrinh = "";
      _soThuNhat = 0;
      _soThuHai = 0;
      _phepTinh = "";
      _choSoTiepTheo = false;
    });
  }

  // =============================
  // DẤU CHẤM THẬP PHÂN
  // =============================
  void _themDauCham() {
    if (!_manHinh.contains(".")) {
      setState(() => _manHinh += ".");
    }
  }

  // =============================
  // ĐỔI DẤU ÂM/DƯƠNG
  // =============================
  void _doiDau() {
    setState(() {
      if (_manHinh.startsWith('-')) {
        _manHinh = _manHinh.substring(1);
      } else if (_manHinh != "0") {
        _manHinh = "-$_manHinh";
      }
    });
  }

  // =============================
  // PHẦN TRĂM
  // =============================
  void _tinhPhanTram() {
    setState(() {
      double giaTri = double.tryParse(_manHinh) ?? 0;
      _manHinh = (giaTri / 100).toString();
    });
  }

  // =============================
  // PHÉP TÍNH + - × ÷
  // =============================
  void _thucHienPhepTinh(String phepTinh) {
    setState(() {
      _soThuNhat = double.tryParse(_manHinh) ?? 0;
      _phepTinh = phepTinh;
      _phuongTrinh = "$_manHinh $phepTinh";
      _choSoTiepTheo = true;
    });
  }

  // =============================
  // TÍNH KẾT QUẢ
  // =============================
  void _tinhKetQua() {
    setState(() {
      _soThuHai = double.tryParse(_manHinh) ?? 0;

      double ketQua = _soThuNhat;

      switch (_phepTinh) {
        case "+":
          ketQua = _soThuNhat + _soThuHai;
          break;
        case "-":
          ketQua = _soThuNhat - _soThuHai;
          break;
        case "×":
          ketQua = _soThuNhat * _soThuHai;
          break;
        case "÷":
          if (_soThuHai == 0) {
            _manHinh = "Lỗi";
            return;
          }
          ketQua = _soThuNhat / _soThuHai;
          break;
        default:
          return;
      }

      _manHinh = ketQua.toString();
      if (_manHinh.endsWith(".0")) {
        _manHinh = _manHinh.replaceAll(".0", "");
      }

      _phuongTrinh = "";
      _phepTinh = "";
      _choSoTiepTheo = true;
    });
  }

  // =============================
  // WIDGET NÚT BẤM
  // =============================
  Widget _nutBam(String text, {Color? mauSac, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: mauSac ?? const Color(0xFF4F5D75),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // =============================
  // XÂY DỰNG GIAO DIỆN
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3142),
      body: SafeArea(
        child: Column(
          children: [
            // Hiển thị
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _phuongTrinh,
                      style: const TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _manHinh,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Các nút bấm
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _nutBam(
                      "C",
                      mauSac: const Color(0xFFEF8354),
                      onTap: _xoaTatCa,
                    ),
                    _nutBam(
                      "CE",
                      mauSac: const Color(0xFFEF8354),
                      onTap: _xoaKyTuCuoi,
                    ),
                    _nutBam(
                      "%",
                      mauSac: const Color(0xFFEF8354),
                      onTap: _tinhPhanTram,
                    ),
                    _nutBam(
                      "÷",
                      mauSac: const Color(0xFFEF8354),
                      onTap: () => _thucHienPhepTinh("÷"),
                    ),

                    _nutBam("7", onTap: () => _nhanSo("7")),
                    _nutBam("8", onTap: () => _nhanSo("8")),
                    _nutBam("9", onTap: () => _nhanSo("9")),
                    _nutBam(
                      "×",
                      mauSac: const Color(0xFFEF8354),
                      onTap: () => _thucHienPhepTinh("×"),
                    ),

                    _nutBam("4", onTap: () => _nhanSo("4")),
                    _nutBam("5", onTap: () => _nhanSo("5")),
                    _nutBam("6", onTap: () => _nhanSo("6")),
                    _nutBam(
                      "-",
                      mauSac: const Color(0xFFEF8354),
                      onTap: () => _thucHienPhepTinh("-"),
                    ),

                    _nutBam("1", onTap: () => _nhanSo("1")),
                    _nutBam("2", onTap: () => _nhanSo("2")),
                    _nutBam("3", onTap: () => _nhanSo("3")),
                    _nutBam(
                      "+",
                      mauSac: const Color(0xFFEF8354),
                      onTap: () => _thucHienPhepTinh("+"),
                    ),

                    _nutBam("±", onTap: _doiDau),
                    _nutBam("0", onTap: () => _nhanSo("0")),
                    _nutBam(".", onTap: _themDauCham),
                    _nutBam(
                      "=",
                      mauSac: const Color(0xFFEF8354),
                      onTap: _tinhKetQua,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
