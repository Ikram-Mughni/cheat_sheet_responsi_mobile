import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  static const Color _portalGreen = Color(0xFF97CE4C);
  static const Color _rickCyan = Color(0xFF00B5CC);
  static const Color _darkCard = Color(0xFF161B26);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Akun Multiverse',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: const Color(0xFF131720),
        foregroundColor: _rickCyan,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _portalGreen.withOpacity(0.12),
                    border: Border.all(color: _portalGreen.withOpacity(0.4), width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.person_add_alt_1, size: 36, color: _portalGreen),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: _darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _rickCyan.withOpacity(0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: _rickCyan.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Registrasi Penjelajah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Silakan masukkan username dan password yang Anda inginkan untuk mendaftar',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 22),

                      TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.account_circle_outlined, color: _rickCyan),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.key_outlined, color: _rickCyan),
                        ),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 50,
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _rickCyan,
                              foregroundColor: const Color(0xFF0D1117),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _authController.isLoading
                                ? null
                                : () {
                                    _authController.register(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                                  },
                            child: _authController.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0D1117),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'DAFTAR SEKARANG',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                TextButton.icon(
                  onPressed: () => Get.offNamed(AppRoutes.login),
                  icon: const Icon(Icons.arrow_back, size: 18, color: _portalGreen),
                  label: const Text(
                    'Sudah punya akun? Kembali ke Login',
                    style: TextStyle(color: _portalGreen, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
