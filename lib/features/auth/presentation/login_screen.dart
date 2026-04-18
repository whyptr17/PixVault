import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            context.go('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.danger),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Unlock Your\nVault',
                        style: AppTextStyles.display,
                      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
                      
                      const SizedBox(height: AppSpacing.xxl),
                      
                      // Custom Tab Bar
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            color: AppColors.bgTertiary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.divider, width: 1),
                          ),
                          labelStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                          unselectedLabelColor: AppColors.textSecondary,
                          tabs: const [
                            Tab(text: 'Login'),
                            Tab(text: 'Register'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: AppSpacing.xxxl),

                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Login Form
                            _buildLoginForm(state),
                            // Register Form
                            _buildRegisterForm(state),
                          ],
                        ),
                      ),

                      // Social Login
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Or continue with',
                              style: AppTextStyles.label.copyWith(color: AppColors.textTertiary),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SocialButton(
                                  icon: Icons.g_mobiledata,
                                  onTap: () => context.read<AuthCubit>().signInWithGoogle(),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                _SocialButton(
                                  icon: Icons.apple,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Apple Sign-In not implemented yet.')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 800.ms),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthState state) {
    return Column(
      children: [
        AppInput(
          controller: _emailController,
          hintText: 'Email address',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInput(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Iconsax.lock,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Login',
          isLoading: state is AuthLoading,
          onTap: () => context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(AuthState state) {
    return Column(
      children: [
        AppInput(
          controller: _nameController,
          hintText: 'Full name',
          prefixIcon: Iconsax.user,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInput(
          controller: _emailController,
          hintText: 'Email address',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInput(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Iconsax.lock,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Create Account',
          isLoading: state is AuthLoading,
          onTap: () => context.read<AuthCubit>().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
