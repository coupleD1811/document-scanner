import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../register/register_page.dart';
import '../repository/auth_repository.dart';
import '../view/auth_failure_message.dart';
import '../view/auth_snack_bar.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _LoginHeader(),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.loginTitle,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.loginSubtitle,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),
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
                                      labelText: l10n.emailLabel,
                                      hintText: l10n.emailHint,
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                      ),
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
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: l10n.passwordLabel,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      errorText: _passwordError,
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? l10n.showPasswordTooltip
                                            : l10n.hidePasswordTooltip,
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
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
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) =>
                                    previous.status != current.status,
                                builder: (context, state) {
                                  final isBusy =
                                      state.status == LoginStatus.inProgress;

                                  return TextButton(
                                    onPressed: isBusy
                                        ? null
                                        : _sendPasswordReset,
                                    child: Text(l10n.forgotPasswordAction),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<LoginBloc, LoginState>(
                              buildWhen: (previous, current) =>
                                  previous.status != current.status,
                              builder: (context, state) {
                                final isBusy =
                                    state.status == LoginStatus.inProgress;

                                return FilledButton.icon(
                                  key: const ValueKey('auth-primary-button'),
                                  onPressed: isBusy ? null : _submit,
                                  icon: isBusy
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.login),
                                  label: Text(l10n.loginAction),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              key: const ValueKey('open-register-button'),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_add_alt_1),
                              label: Text(l10n.createNewAccountAction),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    final l10n = context.l10n;
    final emailError = _validateEmail(l10n, email);
    final passwordError = _validatePassword(l10n, password);

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
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Icon(
              Icons.document_scanner_outlined,
              color: colorScheme.onPrimary,
              size: 34,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Scanly', style: textTheme.headlineMedium),
              Text(
                l10n.secureWorkspaceTagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String? _validateEmail(AppLocalizations l10n, String email) {
  if (email.isEmpty) {
    return l10n.emailRequired;
  }

  final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  if (!isValid) {
    return l10n.emailInvalid;
  }

  return null;
}

String? _validatePassword(AppLocalizations l10n, String password) {
  if (password.isEmpty) {
    return l10n.passwordRequired;
  }

  if (password.length < 6) {
    return l10n.passwordMinLength;
  }

  return null;
}

String? _snackBarMessage(BuildContext context, LoginState state) {
  final l10n = context.l10n;

  if (state.failureCode != null) {
    return state.failureCode!.localizedMessage(l10n);
  }

  return switch (state.successMessage) {
    LoginSuccessMessage.signedIn => l10n.signInSuccess,
    LoginSuccessMessage.passwordResetEmailSent => l10n.passwordResetEmailSent,
    null => null,
  };
}
