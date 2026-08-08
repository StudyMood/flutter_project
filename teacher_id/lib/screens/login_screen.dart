import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_container.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@digicoders.com');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _isLoading = false;
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.admin;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(
      _emailController.text,
      _passwordController.text,
      role: _selectedRole,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryOrange.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryGreen.withOpacity(0.2),
              ),
            ),
          ),

          // Main Login Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.badge_rounded,
                        size: 48,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'DigiCoders',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryOrange,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'Intern Digital ID Card System',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryGreen,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login Glass Container Form
                    GlassContainer(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign In to Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Role Switcher Segmented Control
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedRole = UserRole.admin),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _selectedRole == UserRole.admin
                                              ? AppTheme.primaryOrange
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Admin',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _selectedRole == UserRole.admin
                                                ? Colors.white
                                                : (isDark ? Colors.grey : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedRole = UserRole.intern),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: _selectedRole == UserRole.intern
                                              ? AppTheme.secondaryGreen
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Intern',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _selectedRole == UserRole.intern
                                                ? Colors.white
                                                : (isDark ? Colors.grey : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryOrange),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Enter email';
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primaryOrange),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'Enter password';
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(_selectedRole == UserRole.admin ? 'Login as Admin' : 'Login as Intern'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Powered by DigiCoders Technologies',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
