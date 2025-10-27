import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

/// Elegant Purple themed Signup app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D28D9)),
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers (kept from the sample file)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreed = false;

  // small press animation for the button
  late final AnimationController _pressController;
  late final Animation<double> _pressAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.06,
    );
    _pressAnim = Tween<double>(begin: 1.0, end: 0.96).animate(_pressController);
  }

  @override
  void dispose() {
    _pressController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Validators — follows the sample logic but slightly improved UX
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmailSampleStyle(String? value) {
    // sample doc used a simple contains('@') check — we keep compatibility,
    // but also ensure there's something before/after '@'
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    final v = value.trim();
    if (!v.contains('@') || v.split('@').length != 2 || v.split('@')[0].isEmpty || v.split('@')[1].isEmpty) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePasswordSample(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmSample(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  void _onSignUp() {
    // follow sample: validate and show success snackbar (we also navigate to Welcome)
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions to continue.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      // show sample-style success feedback + navigate
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome! Account created successfully.'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 900),
        ),
      );

      // small delay for the snackbar to appear (quick) then navigate with a fade
      Future.delayed(const Duration(milliseconds: 350), () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: WelcomeScreen(name: _nameController.text.trim()),
              );
            },
          ),
        );
      });
    } else {
      // mimic the sample behaviour where validation shows the errors inline
      // and we give a gentle hint
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix errors and try again.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  InputDecoration _fieldDecoration({required String label, Widget? prefix, Widget? suffix, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      // no appbar — we create a beautiful header inside body to match premium UI
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6D28D9).withOpacity(0.98),
              const Color(0xFF8B5CF6).withOpacity(0.92),
              const Color(0xFFB794F4).withOpacity(0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: mq.size.width > 700 ? 700 : mq.size.width - 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // header row (keeps the playful title from sample file)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.handshake, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                            Text('Join Us Today for the Cash Money!',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Create your account — quick and simple',
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // card container holds the sample form but upgraded
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.98),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 8))],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // sample welcome message (kept verbatim style)
                            const Text('Create Your Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 14),
                            const Text('Sign up with your details below', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 18),

                            // Full Name (sample field)
                            TextFormField(
                              controller: _nameController,
                              validator: _validateName,
                              textInputAction: TextInputAction.next,
                              decoration: _fieldDecoration(label: 'Full Name', prefix: const Icon(Icons.person)),
                            ),
                            const SizedBox(height: 14),

                            // Email (sample validator style)
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: _validateEmailSampleStyle,
                              decoration: _fieldDecoration(label: 'Email Address', prefix: const Icon(Icons.email), hint: 'you@domain.com'),
                            ),
                            const SizedBox(height: 14),

                            // Password from sample
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              validator: _validatePasswordSample,
                              decoration: _fieldDecoration(
                                label: 'Password',
                                prefix: const Icon(Icons.lock),
                                hint: 'At least 6 characters',
                                suffix: IconButton(
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Confirm Password (challenge from the document)
                            TextFormField(
                              controller: _confirmController,
                              obscureText: _obscureConfirm,
                              textInputAction: TextInputAction.done,
                              validator: _validateConfirmSample,
                              decoration: _fieldDecoration(
                                label: 'Confirm Password',
                                prefix: const Icon(Icons.lock_outline),
                                suffix: IconButton(
                                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Terms row (keeps sample's emphasis on acceptance)
                            Row(
                              children: [
                                Checkbox(value: _agreed, onChanged: (v) => setState(() => _agreed = v ?? false)),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _agreed = !_agreed),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I agree to the ',
                                        style: TextStyle(color: Colors.grey[800]),
                                        children: [
                                          TextSpan(
                                            text: 'Terms & Conditions',
                                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Sign Up button (sample logic wired here)
                            GestureDetector(
                              onTapDown: (_) => _pressController.forward(),
                              onTapUp: (_) => _pressController.reverse(),
                              onTapCancel: () => _pressController.reverse(),
                              onTap: _onSignUp,
                              child: AnimatedBuilder(
                                animation: _pressAnim,
                                builder: (context, child) {
                                  return Transform.scale(scale: _pressAnim.value, child: child);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)]),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.deepPurple.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 6))],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // small footer actions (keeps sample's 'login' mention)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?', style: TextStyle(color: Colors.grey[700])),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login flow not implemented in this demo')));
                                  },
                                  child: const Text('Login'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // subtle privacy note (keeps the doc's friendly tone)
                    Column(
                      children: [
                        Text('We respect your privacy. Your information is safe with us.', style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
                        const SizedBox(height: 6),
                        Text('Version 1.0 MAD Inclass-12', style: TextStyle(color: Colors.white60, fontSize: 11)),
                        const SizedBox(height: 8),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final String name;
  const WelcomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final shortName = name.isEmpty ? 'Friend' : name.split(' ').first;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 18, offset: Offset(0, 8))]),
                child: const Icon(Icons.emoji_people, size: 64, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text('Welcome, $shortName!', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Your account has been created successfully.', style: TextStyle(color: Colors.white70, fontSize: 15), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.deepPurple, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Continue'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}