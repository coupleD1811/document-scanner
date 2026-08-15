import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/l10n.dart';
import '../presentation/widgets/auth_failure_message.dart';
import '../presentation/widgets/auth_form_widgets.dart';
import '../presentation/widgets/auth_snack_bar.dart';
import '../register/register_page.dart';
import '../repository/auth_repository.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(authRepository: context.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  static const _googleIconPath = 'images/logo/google_icon.png';
  static const _facebookIconPath = 'images/logo/facebook_icon.png';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.failureCode != current.failureCode ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final message = _snackBarMessage(context, state);
        if (message == null) {
          return;
        }

        showAuthSnackBar(
          context,
          message: message,
          isError: state.failureCode != null,
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: AuthBrandLogo()),
                          const SizedBox(height: 40),
                          Text(
                            t.loginWelcomeTitle,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.secureWorkspaceTagline,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 34),
                          AutofillGroup(
                            child: Column(
                              children: [
                                TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: _inputDecoration(
                                    context,
                                    hintText: t.emailLabel,
                                    prefixIcon: LucideIcons.mail,
                                    errorText: _emailError,
                                  ),
                                  onSubmitted: (_) =>
                                      _passwordFocusNode.requestFocus(),
                                  onChanged: (_) {
                                    if (_emailError != null) {
                                      setState(() => _emailError = null);
                                    }
                                  },
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: _inputDecoration(
                                    context,
                                    hintText: t.passwordLabel,
                                    prefixIcon: LucideIcons.lockKeyhole,
                                    errorText: _passwordError,
                                    suffixIcon: IconButton(
                                      tooltip: _obscurePassword
                                          ? t.showPasswordTooltip
                                          : t.hidePasswordTooltip,
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: Icon(
                                        _obscurePassword
                                            ? LucideIcons.eye
                                            : LucideIcons.eyeOff,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) => _submit(),
                                  onChanged: (_) {
                                    if (_passwordError != null) {
                                      setState(() => _passwordError = null);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: BlocBuilder<LoginBloc, LoginState>(
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                final isBusy =
                                    state.status == LoginStatus.inProgress;

                                return TextButton(
                                  onPressed: isBusy ? null : _sendPasswordReset,
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(0, 40),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(t.forgotPasswordAction),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.status != current.status,
                            builder: (context, state) {
                              final isBusy =
                                  state.status == LoginStatus.inProgress;

                              return FilledButton(
                                key: const ValueKey('auth-primary-button'),
                                onPressed: isBusy ? null : _submit,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(56),
                                  textStyle: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: isBusy
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: colorScheme.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(t.loginAction),
                              );
                            },
                          ),
                          const SizedBox(height: 26),
                          AuthDivider(text: t.orDivider),
                          const SizedBox(height: 26),
                          AuthSocialButton(
                            assetPath: _googleIconPath,
                            label: t.continueWithGoogle,
                            onPressed: _showSocialComingSoon,
                          ),
                          const SizedBox(height: 12),
                          AuthSocialButton(
                            assetPath: _facebookIconPath,
                            label: t.continueWithFacebook,
                            onPressed: _showSocialComingSoon,
                          ),
                          const SizedBox(height: 30),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            children: [
                              Text(
                                t.dontHaveAccountPrompt,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextButton(
                                key: const ValueKey('open-register-button'),
                                onPressed: _openRegister,
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 40),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(t.createAccountAction),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final t = context.l10n;
    final emailError = _validateEmail(t, email);
    final passwordError = _validatePassword(t, password);

    if (emailError != null || passwordError != null) {
      setState(() {
        _emailError = emailError;
        _passwordError = passwordError;
      });
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }

  void _openRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const RegisterPage()));
  }

  void _sendPasswordReset() {
    final email = _emailController.text.trim();
    final emailError = _validateEmail(context.l10n, email);

    if (emailError != null) {
      setState(() => _emailError = emailError);
      _emailFocusNode.requestFocus();
      return;
    }

    context.read<LoginBloc>().add(LoginPasswordResetRequested(email: email));
  }

  void _showSocialComingSoon() {
    showAuthSnackBar(
      context,
      message: context.l10n.socialLoginComingSoon,
      isError: false,
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    required IconData prefixIcon,
    required String? errorText,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: colorScheme.outline),
      suffixIcon: suffixIcon,
      errorText: errorText,
    );
  }
}

String? _validateEmail(AppLocalizations t, String email) {
  if (email.isEmpty) {
    return t.emailRequired;
  }

  final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  if (!isValid) {
    return t.emailInvalid;
  }

  return null;
}

String? _validatePassword(AppLocalizations t, String password) {
  if (password.isEmpty) {
    return t.passwordRequired;
  }

  if (password.length < 6) {
    return t.passwordMinLength;
  }

  return null;
}

String? _snackBarMessage(BuildContext context, LoginState state) {
  final t = context.l10n;

  if (state.failureCode != null) {
    return state.failureCode!.localizedMessage(t);
  }

  return switch (state.successMessage) {
    LoginSuccessMessage.signedIn => t.signInSuccess,
    LoginSuccessMessage.passwordResetEmailSent => t.passwordResetEmailSent,
    null => null,
  };
}
