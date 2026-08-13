import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../presentation/widgets/auth_failure_message.dart';
import '../presentation/widgets/auth_form_widgets.dart';
import '../presentation/widgets/auth_snack_bar.dart';
import '../repository/auth_repository.dart';
import '../session/bloc/auth_session_bloc.dart';
import 'bloc/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegisterBloc(authRepository: context.read<AuthRepository>()),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  static const _googleIconPath = 'images/logo/google_icon.png';
  static const _facebookIconPath = 'images/logo/facebook_icon.png';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
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
        ),
        BlocListener<AuthSessionBloc, AuthSessionState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == AuthSessionStatus.authenticated) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        ),
      ],
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
                            t.createAccountTitle,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            t.registerSubtitle,
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
                                    prefixIcon: Icons.mail_outline,
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
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  decoration: _inputDecoration(
                                    context,
                                    hintText: t.passwordLabel,
                                    prefixIcon: Icons.lock_outline,
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
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) =>
                                      _confirmPasswordFocusNode.requestFocus(),
                                  onChanged: (_) {
                                    if (_passwordError != null) {
                                      setState(() => _passwordError = null);
                                    }
                                  },
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocusNode,
                                  obscureText: _obscureConfirmPassword,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  decoration: _inputDecoration(
                                    context,
                                    hintText: t.confirmPasswordLabel,
                                    prefixIcon: Icons.lock_outline,
                                    errorText: _confirmPasswordError,
                                    suffixIcon: IconButton(
                                      tooltip: _obscureConfirmPassword
                                          ? t.showPasswordTooltip
                                          : t.hidePasswordTooltip,
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) => _submit(),
                                  onChanged: (_) {
                                    if (_confirmPasswordError != null) {
                                      setState(
                                        () => _confirmPasswordError = null,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          BlocBuilder<RegisterBloc, RegisterState>(
                            buildWhen: (previous, current) =>
                                previous.status != current.status,
                            builder: (context, state) {
                              final isBusy =
                                  state.status == RegisterStatus.inProgress;

                              return FilledButton(
                                key: const ValueKey('register-primary-button'),
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
                                    : Text(t.createAccountAction),
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
                                t.alreadyHaveAccountPrompt,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextButton(
                                onPressed: _goBackToLogin,
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 40),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(t.loginAction),
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
    final confirmPassword = _confirmPasswordController.text;
    final t = context.l10n;
    final emailError = _validateEmail(t, email);
    final passwordError = _validatePassword(t, password);
    final confirmPasswordError = _validateConfirmPassword(
      t,
      password,
      confirmPassword,
    );

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      setState(() {
        _emailError = emailError;
        _passwordError = passwordError;
        _confirmPasswordError = confirmPasswordError;
      });
      return;
    }

    context.read<RegisterBloc>().add(
      RegisterSubmitted(email: email, password: password),
    );
  }

  void _goBackToLogin() {
    Navigator.of(context).maybePop();
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

String? _snackBarMessage(BuildContext context, RegisterState state) {
  final t = context.l10n;

  if (state.failureCode != null) {
    return state.failureCode!.localizedMessage(t);
  }

  return switch (state.successMessage) {
    RegisterSuccessMessage.accountCreated => t.accountCreatedSuccess,
    null => null,
  };
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

String? _validateConfirmPassword(
  AppLocalizations t,
  String password,
  String confirmPassword,
) {
  if (confirmPassword.isEmpty) {
    return t.confirmPasswordRequired;
  }

  if (password != confirmPassword) {
    return t.confirmPasswordMismatch;
  }

  return null;
}
