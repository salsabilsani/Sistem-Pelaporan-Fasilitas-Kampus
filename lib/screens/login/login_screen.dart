import 'package:flutter/material.dart';

typedef SignInAction = Future<String?> Function(
  String email,
  String password,
);

class LoginScreen extends StatefulWidget {
  final SignInAction? onSignIn;
  final VoidCallback? onSignedIn;
  final VoidCallback? onRegister;
  final VoidCallback? onPreview;

  const LoginScreen({
    super.key,
    this.onSignIn,
    this.onSignedIn,
    this.onRegister,
    this.onPreview,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _primary = Color(0xFF2B124C);
  static const _buttonColor = Color(0xFF42165C);
  static const _background = Color(0xFFF8F6FA);
  static const _textColor = Color(0xFF281735);
  static const _secondaryText = Color(0xFF695A75);
  static const _borderColor = Color(0xFFBCA9CA);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final signIn = widget.onSignIn;

    if (signIn == null) {
      setState(() {
        _errorMessage =
            'Login belum terhubung ke layanan autentikasi.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? error;

    try {
      error = await signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (_) {
      error = 'Belum bisa masuk. Silakan coba kembali.';
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      _passwordController.clear();
      widget.onSignedIn?.call();
    }
  }

  void _openRegistration() {
    if (widget.onRegister != null) {
      widget.onRegister!();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Halaman registrasi belum tersedia.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  OutlineInputBorder _inputBorder(
    Color color, {
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8D7C9B),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFFCFAFF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      prefixIcon: Icon(
        icon,
        color: _primary,
        size: 22,
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      suffixIcon: suffixIcon,
      border: _inputBorder(_borderColor),
      enabledBorder: _inputBorder(_borderColor),
      focusedBorder: _inputBorder(
        _primary,
        width: 1.6,
      ),
      disabledBorder: _inputBorder(
        const Color(0xFFDDD3E5),
      ),
      errorBorder: _inputBorder(
        const Color(0xFFB3261E),
      ),
      focusedErrorBorder: _inputBorder(
        const Color(0xFFB3261E),
        width: 1.6,
      ),
      errorMaxLines: 2,
      errorStyle: const TextStyle(
        fontSize: 12,
        height: 1.3,
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      child: Column(
        children: [
          Semantics(
            label: 'SILAPOR',
            header: true,
            child: const ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.apartment_rounded,
                      size: 48,
                      color: _primary,
                    ),
                    SizedBox(width: 9),
                    Text(
                      'SILAPOR',
                      style: TextStyle(
                        color: _primary,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fasilitas baik, kampus nyaman.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _secondaryText,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampusImage() {
    return AspectRatio(
      aspectRatio: 2.45,
      child: Image.asset(
        'assets/images/kampus_silapor.png',
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        excludeFromSemantics: true,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: _textColor,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Email'),
        Semantics(
          label: 'Email',
          child: TextFormField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [
              AutofillHints.username,
            ],
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(
              color: _textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hint: 'nama@student.uns.ac.id',
              icon: Icons.mail_outline_rounded,
            ),
            validator: (value) {
              final email = value?.trim() ?? '';

              if (email.isEmpty) {
                return 'Email wajib diisi.';
              }

              final emailPattern =
                  RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

              if (!emailPattern.hasMatch(email)) {
                return 'Masukkan alamat email yang valid.';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Password'),
        Semantics(
          label: 'Password',
          child: TextFormField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [
              AutofillHints.password,
            ],
            autocorrect: false,
            enableSuggestions: false,
            onFieldSubmitted: (_) => _login(),
            style: const TextStyle(
              color: _textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hint: 'Masukkan password',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                tooltip: _obscurePassword
                    ? 'Tampilkan password'
                    : 'Sembunyikan password',
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _primary,
                  size: 22,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password wajib diisi.';
              }

              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: Color(0xFF9C263F),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Color(0xFF9C263F),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _isLoading ? null : _login,
        style: FilledButton.styleFrom(
          backgroundColor: _buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD8C8E2),
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: _primary,
                ),
              )
            : const Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Belum punya akun?',
          style: TextStyle(
            color: _secondaryText,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : _openRegistration,
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
          ),
          child: const Text(
            'Daftar',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
              decorationColor: _primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode:
              AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selamat datang kembali',
                style: TextStyle(
                  color: _primary,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Masuk untuk melaporkan fasilitas kampus.',
                style: TextStyle(
                  color: _secondaryText,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              _buildEmailField(),
              const SizedBox(height: 19),
              _buildPasswordField(),
              if (_errorMessage != null)
                _buildErrorMessage(),
              const SizedBox(height: 26),
              _buildLoginButton(),
              const SizedBox(height: 10),
              Center(
                child: _buildRegisterLink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final outerPadding = isWide ? 32.0 : 0.0;

            final minimumHeight =
                constraints.maxHeight > outerPadding * 2
                    ? constraints.maxHeight -
                        outerPadding * 2
                    : 0.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(outerPadding),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minimumHeight,
                ),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 440,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(
                        isWide ? 28 : 0,
                      ),
                      border: isWide
                          ? Border.all(
                              color: const Color(0xFFD9CDE4),
                            )
                          : null,
                      boxShadow: isWide
                          ? const [
                              BoxShadow(
                                color: Color(0x162B124C),
                                blurRadius: 32,
                                offset: Offset(0, 12),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildBrand(),
                        _buildCampusImage(),
                        _buildForm(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}