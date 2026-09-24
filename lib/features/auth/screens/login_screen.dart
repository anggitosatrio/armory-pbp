import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../auth_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateForm() async {
  final isValid = _formKey.currentState?.validate() ?? false;

  if (!isValid) {
    return;
  }

  final auth = AuthScope.of(context);

  final success = await auth.login(
    email: _emailController.text,
    password: _passwordController.text,
  );

  if (!mounted || success) {
    return;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 800;

            if (isCompact) {
              return _buildCompactLayout();
            }

            return _buildDesktopLayout();
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _buildBrandPanel(),
        ),
        Expanded(
          flex: 5,
          child: _buildLoginPanel(),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 460,
          ),
          child: _buildLoginPanel(),
        ),
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'ARMORY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 42,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'TACTICAL INVENTORY SYSTEM',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SizedBox(
            width: 460,
            child: Text(
              'A centralized interface for browsing, organizing, '
              'and monitoring your inventory catalog.',
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPanel() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileBrand(),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Welcome back',
                  style: AppTextStyles.headline,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Sign in to access the ARMORY inventory system.',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xl),
                _buildEmailField(),
                const SizedBox(height: AppSpacing.md),
                _buildPasswordField(),
                const SizedBox(height: AppSpacing.md),
                _buildAuthError(),
                const SizedBox(height: AppSpacing.lg),
                _buildSignInButton(),
                const SizedBox(height: AppSpacing.xl),
                _buildDemoNotice(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBrand() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Text(
          'ARMORY',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: (value) {
        final email = value?.trim() ?? '';

        if (email.isEmpty) {
          return 'Email is required';
        }

        final emailPattern = RegExp(
          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
        );

        if (!emailPattern.hasMatch(email)) {
          return 'Enter a valid email';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          tooltip: _obscurePassword
              ? 'Show password'
              : 'Hide password',
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        final password = value ?? '';

        if (password.isEmpty) {
          return 'Password is required';
        }

        if (password.length < 6) {
          return 'Password must be at least 6 characters';
        }

        return null;
      },
      onFieldSubmitted: (_) {
        _validateForm();
      },
    );
  }

  Widget _buildAuthError() {
  final auth = AuthScope.of(context);

  if (auth.errorMessage == null) {
    return const SizedBox.shrink();
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.error.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.error.withValues(alpha: 0.35),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.error_outline,
          size: 20,
          color: AppColors.error,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            auth.errorMessage!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSignInButton() {
  final auth = AuthScope.of(context);

  return SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: auth.isLoading ? null : _validateForm,
      child: auth.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Text('SIGN IN'),
    ),
  );
}

  Widget _buildDemoNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Demo environment. Authentication will be '
              'implemented in the next stage.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}