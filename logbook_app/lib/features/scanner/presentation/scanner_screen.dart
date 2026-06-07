import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../../models/card_model.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final _codeInputController = TextEditingController();
  
  bool _isLoading = false;
  bool _isCameraMode = true; 
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _codeInputController.dispose();
    super.dispose();
  }

  Future<void> _scanCard() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return; 

      setState(() => _isLoading = true);

      final uri = Uri.parse('http://127.0.0.1:5000/scan'); 
      
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Tempo de conexão esgotado. Verifique o IP ou o Firewall.");
        },
      );
      
      final responseData = await response.stream.bytesToString();
      final json = jsonDecode(responseData);

      if (json['status'] == 'sucesso') {
        final String cardId = json['cardId'];
        await _fetchCardAndNavigate(cardId);
      } else {
        _showError('Carta não reconhecida. Tente novamente.');
      }
    } catch (e, stacktrace) {
      debugPrint("ERRO CRÍTICO NO SCAN: $e");
      debugPrint("STACKTRACE: $stacktrace");
      _showError('Erro de conexão. Verifique o IP e o Wi-Fi.'); 
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchByCode() async {
    final code = _codeInputController.text.trim().toUpperCase(); 
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    await _fetchCardAndNavigate(code);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchCardAndNavigate(String cardId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('cards').doc(cardId).get();
      
      if (doc.exists) {
        final card = CardModel.fromMap(doc.data()!, doc.id);
        if (mounted) {
          _codeInputController.clear(); 
          context.push('/card_detail', extra: card);
        }
      } else {
        _showError('Carta ($cardId) não encontrada no banco.');
      }
    } catch (e) {
      _showError('Erro ao consultar o banco.');
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg, style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF111111), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.pop(),
                      ),
                      _buildGlassButton(
                        icon: Icons.flash_on,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Flash indisponível no ImagePicker')));
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Aponte para a carta ou insira o código',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),

                const Spacer(),

                if (_isCameraMode) 
                  _buildCameraView()
                else 
                  _buildManualCodeView(),

                const Spacer(),
                const SizedBox(height: 100), 
              ],
            ),
          ),

          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCameraMode = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isCameraMode ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.camera, color: _isCameraMode ? Colors.white : Colors.white60),
                                const SizedBox(height: 4),
                                Text('Reconhecer pela câmera', style: TextStyle(color: _isCameraMode ? Colors.white : Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isCameraMode = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isCameraMode ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.qr_code_scanner, color: !_isCameraMode ? Colors.white : Colors.white60),
                                const SizedBox(height: 4),
                                Text('Buscar por código', style: TextStyle(color: !_isCameraMode ? Colors.white : Colors.white60, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Processando...', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return GestureDetector(
      onTap: _scanCard,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 260,
            height: 364, 
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Stack(
              children: [
                Positioned(top: -2, left: -2, child: _buildCornerMarker(top: true, left: true)),
                Positioned(top: -2, right: -2, child: _buildCornerMarker(top: true, left: false)),
                Positioned(bottom: -2, left: -2, child: _buildCornerMarker(top: false, left: true)),
                Positioned(bottom: -2, right: -2, child: _buildCornerMarker(top: false, left: false)),
                
                Center(
                  child: Icon(Icons.camera_alt, color: Colors.white.withOpacity(0.2), size: 64),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Toque no quadro para scannear',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualCodeView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.qr_code, size: 80, color: AppColors.primary),
          const SizedBox(height: 24),
          const Text('Ex: OP15-092', style: TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 16),
          TextField(
            controller: _codeInputController,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Digite o código da carta',
              hintStyle: const TextStyle(color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _searchByCode(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _searchByCode,
              child: const Text('Buscar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCornerMarker({required bool top, required bool left}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          left: left ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          right: !left ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: top && left ? const Radius.circular(14) : Radius.zero,
          topRight: top && !left ? const Radius.circular(14) : Radius.zero,
          bottomLeft: !top && left ? const Radius.circular(14) : Radius.zero,
          bottomRight: !top && !left ? const Radius.circular(14) : Radius.zero,
        ),
      ),
    );
  }
}