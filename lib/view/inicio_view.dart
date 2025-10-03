import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

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
    // Espera unos segundos para simular carga
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/inventory-list-screen');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cambiar color de la barra de estado
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.blue,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor:const Color(0xFF192338),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Logo
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
            SizedBox(height: 8.h),
            // Título
            FadeTransition(opacity: _fadeAnimation, child: _buildAppTitle()),
            SizedBox(height: 4.h),
            // Subtítulo
            FadeTransition(opacity: _fadeAnimation, child: _buildAppSubtitle()),
            const Spacer(flex: 1),
            // Loading
            FadeTransition(opacity: _fadeAnimation, child: _buildLoading()),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
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
