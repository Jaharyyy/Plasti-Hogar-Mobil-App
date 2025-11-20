import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'login.dart';

class InicioScreen extends StatefulWidget {
  final dynamic authResponse;

  const InicioScreen({super.key, required this.authResponse});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 6500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores del sistema
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF192338),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF192338),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF192338),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 👈 centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // 👈 centra horizontalmente
            children: [
              // Logo animado
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildAppLogo(),
                    ),
                  );
                },
              ),
              SizedBox(height: 5.h),

              // Título
              FadeTransition(opacity: _fadeAnimation, child: _buildAppTitle()),
              SizedBox(height: 2.h),

              // Subtítulo
              FadeTransition(opacity: _fadeAnimation, child: _buildAppSubtitle()),
              SizedBox(height: 5.h),

              // Cargando
              FadeTransition(opacity: _fadeAnimation, child: _buildLoading()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage('assets/LOGO.jpg'),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'Plastic House',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAppSubtitle() {
    return Text(
      'Bienvenido otra vez',
      style: TextStyle(fontSize: 12.sp, color: Colors.white70, height: 1.4),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: const CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Inicializando aplicación...',
          style: TextStyle(fontSize: 11.sp, color: Colors.white70),
        ),
      ],
    );
  }
}
