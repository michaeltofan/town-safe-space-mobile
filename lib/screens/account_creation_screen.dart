import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/town_feed_copy.dart';

enum _AccountCreationStep { email, code, passkey, ready }

/// Account Creation V1 — single-route mock flow.
///
/// Local steps: email → code → passkey → account ready.
/// Does not create a real account, send email, call WebAuthn, start payment,
/// create entitlement, or persist personal data.
class AccountCreationScreen extends StatefulWidget {
  const AccountCreationScreen({
    super.key,
    required this.selectedCountry,
    required this.selectedCity,
    required this.copy,
  }) : assert(
         (selectedCountry == 'Italy' && selectedCity == 'Milano') ||
             (selectedCountry == 'Germany' && selectedCity == 'Munich'),
         'Unsupported country/city pair: $selectedCountry / $selectedCity',
       );

  final String selectedCountry;
  final String selectedCity;
  final TownFeedCopy copy;

  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);
  static const Color inkMuted = Color(0x99F5F5F5);
  static const Color fieldFill = Color(0xFF141414);
  static const Color error = Color(0xFFE86A6A);

  static const String validPrototypeCode = '123456';

  @override
  State<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends State<AccountCreationScreen> {
  _AccountCreationStep _currentStep = _AccountCreationStep.email;
  String _emailEntered = '';
  bool _emailVerified = false;
  bool _passkeySimulated = false;
  bool _accountSecured = false;
  String? _validationMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _clearValidation() {
    if (_validationMessage != null) {
      setState(() => _validationMessage = null);
    }
  }

  void _handleBack() {
    switch (_currentStep) {
      case _AccountCreationStep.email:
        Navigator.of(context).pop();
      case _AccountCreationStep.code:
        setState(() {
          _currentStep = _AccountCreationStep.email;
          _validationMessage = null;
          _emailVerified = false;
        });
      case _AccountCreationStep.passkey:
        setState(() {
          _currentStep = _AccountCreationStep.code;
          _validationMessage = null;
          _passkeySimulated = false;
          _accountSecured = false;
        });
      case _AccountCreationStep.ready:
        setState(() {
          _currentStep = _AccountCreationStep.passkey;
          _validationMessage = null;
          _passkeySimulated = false;
          _accountSecured = false;
        });
    }
  }

  void _onEmailContinue() {
    final String trimmed = _emailController.text.trim();
    if (trimmed.isEmpty) {
      setState(() => _validationMessage = widget.copy.accountCreationEmailEmpty);
      return;
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      setState(
        () => _validationMessage = widget.copy.accountCreationEmailInvalid,
      );
      return;
    }
    setState(() {
      _emailEntered = trimmed;
      _emailController.text = trimmed;
      _validationMessage = null;
      _codeController.clear();
      _currentStep = _AccountCreationStep.code;
    });
  }

  void _onCodeVerify() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _validationMessage = widget.copy.accountCreationCodeEmpty);
      return;
    }
    if (code != AccountCreationScreen.validPrototypeCode) {
      setState(
        () => _validationMessage = widget.copy.accountCreationCodeInvalid,
      );
      return;
    }
    setState(() {
      _emailVerified = true;
      _validationMessage = null;
      _currentStep = _AccountCreationStep.passkey;
    });
  }

  void _onChangeEmail() {
    setState(() {
      _currentStep = _AccountCreationStep.email;
      _validationMessage = null;
      _emailVerified = false;
      _codeController.clear();
      // Preserve typed email in the field.
      _emailController.text = _emailEntered;
      _emailController.selection = TextSelection.collapsed(
        offset: _emailController.text.length,
      );
    });
  }

  Future<void> _onPasskeyCreate() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          key: const Key('account_creation_passkey_prototype_dialog'),
          backgroundColor: const Color(0xFF141414),
          title: null,
          content: Text(
            widget.copy.accountCreationPasskeyPrototypeMessage,
            style: const TextStyle(
              fontSize: 16.5,
              height: 1.4,
              color: AccountCreationScreen.ink,
            ),
          ),
          actions: [
            TextButton(
              key: const Key('account_creation_passkey_simulate'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _passkeySimulated = true;
                  _accountSecured = true;
                  _currentStep = _AccountCreationStep.ready;
                });
              },
              child: Text(
                widget.copy.accountCreationPasskeySimulate,
                style: const TextStyle(
                  color: AccountCreationScreen.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onContinueMembership() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          key: const Key('account_creation_payment_boundary_dialog'),
          backgroundColor: const Color(0xFF141414),
          title: null,
          content: Text(
            widget.copy.accountCreationPaymentBoundaryMessage,
            style: const TextStyle(
              fontSize: 16.5,
              height: 1.4,
              color: AccountCreationScreen.ink,
            ),
          ),
          actions: [
            TextButton(
              key: const Key('account_creation_payment_boundary_dismiss'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                widget.copy.accountCreationPaymentBoundaryDismiss,
                style: const TextStyle(
                  color: AccountCreationScreen.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double padX = (MediaQuery.sizeOf(context).width * 0.045).clamp(
      16.0,
      21.6,
    );
    final bool canPopRoute = _currentStep == _AccountCreationStep.email;

    return PopScope(
      canPop: canPopRoute,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _handleBack();
      },
      child: Scaffold(
        key: const Key('account_creation_screen'),
        backgroundColor: AccountCreationScreen.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              padX + safe.left,
              8,
              padX + safe.right,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    key: const Key('account_creation_back'),
                    onPressed: _handleBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                ),
                Expanded(child: _buildStepContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case _AccountCreationStep.email:
        return _buildEmailStep();
      case _AccountCreationStep.code:
        return _buildCodeStep();
      case _AccountCreationStep.passkey:
        return _buildPasskeyStep();
      case _AccountCreationStep.ready:
        return _buildReadyStep();
    }
  }

  Widget _buildEmailStep() {
    final TownFeedCopy copy = widget.copy;
    return KeyedSubtree(
      key: const Key('account_creation_email_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    copy.accountCreationEmailLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationEmailHeadline,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.accountCreationEmailBody,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.accountCreationEmailBodySecond,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationEmailFieldLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('account_creation_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AccountCreationScreen.ink,
                    ),
                    cursorColor: AccountCreationScreen.accent,
                    decoration: InputDecoration(
                      hintText: copy.accountCreationEmailPlaceholder,
                      hintStyle: const TextStyle(
                        color: AccountCreationScreen.inkMuted,
                      ),
                      filled: true,
                      fillColor: AccountCreationScreen.fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => _clearValidation(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationEmailPrivacyNote,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  if (_validationMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _validationMessage!,
                      key: const Key('account_creation_email_error'),
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.35,
                        color: AccountCreationScreen.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('account_creation_email_continue'),
              onPressed: _onEmailContinue,
              style: FilledButton.styleFrom(
                backgroundColor: AccountCreationScreen.accent,
                foregroundColor: const Color(0xFF111111),
                elevation: 0,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(copy.accountCreationEmailContinue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeStep() {
    final TownFeedCopy copy = widget.copy;
    return KeyedSubtree(
      key: const Key('account_creation_code_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    copy.accountCreationCodeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationCodeHeadline,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.accountCreationCodeBody,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _emailEntered,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationCodeFieldLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('account_creation_code_field'),
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                    cursorColor: AccountCreationScreen.accent,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AccountCreationScreen.fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (_) => _clearValidation(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationCodePrototypeNote,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  if (_validationMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _validationMessage!,
                      key: const Key('account_creation_code_error'),
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.35,
                        color: AccountCreationScreen.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('account_creation_code_verify'),
              onPressed: _onCodeVerify,
              style: FilledButton.styleFrom(
                backgroundColor: AccountCreationScreen.accent,
                foregroundColor: const Color(0xFF111111),
                elevation: 0,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(copy.accountCreationCodeVerify),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            key: const Key('account_creation_code_change_email'),
            onPressed: _onChangeEmail,
            style: TextButton.styleFrom(
              foregroundColor: AccountCreationScreen.inkSoft,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(copy.accountCreationCodeChangeEmail),
          ),
        ],
      ),
    );
  }

  Widget _buildPasskeyStep() {
    final TownFeedCopy copy = widget.copy;
    return KeyedSubtree(
      key: const Key('account_creation_passkey_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    copy.accountCreationPasskeyLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationPasskeyHeadline,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.accountCreationPasskeyBody,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.accountCreationPasskeyBodySecond,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationPasskeyBenefit1,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    copy.accountCreationPasskeyBenefit2,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    copy.accountCreationPasskeyBenefit3,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationPasskeyPrototypeMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('account_creation_passkey_create'),
              onPressed: _onPasskeyCreate,
              style: FilledButton.styleFrom(
                backgroundColor: AccountCreationScreen.accent,
                foregroundColor: const Color(0xFF111111),
                elevation: 0,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(copy.accountCreationPasskeyCreate),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyStep() {
    final TownFeedCopy copy = widget.copy;
    assert(_emailVerified && _passkeySimulated && _accountSecured);
    return KeyedSubtree(
      key: const Key('account_creation_ready_step'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    copy.accountCreationReadyLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AccountCreationScreen.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    copy.accountCreationReadyHeadline,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    copy.accountCreationReadyBody,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    copy.accountCreationReadyBodySecond,
                    style: const TextStyle(
                      fontSize: 16.5,
                      height: 1.4,
                      color: AccountCreationScreen.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationReadyEmailStatus,
                    key: const Key('account_creation_email_verified_status'),
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    copy.accountCreationReadyPasskeyStatus,
                    key: const Key('account_creation_passkey_status'),
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    copy.accountCreationReadyNextStep,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                      color: AccountCreationScreen.ink,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: FilledButton(
              key: const Key('account_creation_continue_membership'),
              onPressed: _onContinueMembership,
              style: FilledButton.styleFrom(
                backgroundColor: AccountCreationScreen.accent,
                foregroundColor: const Color(0xFF111111),
                elevation: 0,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              child: Text(copy.accountCreationReadyContinue),
            ),
          ),
        ],
      ),
    );
  }
}
