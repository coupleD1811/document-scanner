import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../presentation/widgets/auth_failure_message.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
        appBar: AppBar(title: Text(t.registerTitle)),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Icons.person_add_alt_1,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                t.createAccountTitle,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.registerSubtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AutofillGroup(
                          child: Column(
                            children: [
                              TextField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                decoration: InputDecoration(
                                  labelText: t.emailLabel,
                                  hintText: t.emailHint,
                                  prefixIcon: const Icon(Icons.mail_outline),
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
                                decoration: InputDecoration(
                                  labelText: t.passwordLabel,
                                  prefixIcon: const Icon(Icons.lock_outline),
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
                                decoration: InputDecoration(
                                  labelText: t.confirmPasswordLabel,
                                  prefixIcon: const Icon(
                                    Icons.verified_user_outlined,
                                  ),
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
                        const SizedBox(height: 22),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (context, state) {
                            final isBusy =
                                state.status == RegisterStatus.inProgress;

                            return FilledButton.icon(
                              key: const ValueKey('register-primary-button'),
                              onPressed: isBusy ? null : _submit,
                              icon: isBusy
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.person_add_alt_1),
                              label: Text(t.createAccountAction),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
