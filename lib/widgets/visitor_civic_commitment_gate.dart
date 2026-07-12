import 'package:flutter/material.dart';

/// Temporary visitor civic-commitment surfaces for the feed.
///
/// Visual chrome matches the approved feed panel language.
/// Copy is fixed English for this controlled step.
class VisitorCivicCommitmentCopy {
  static const String invitationTitle =
      'You care about what happens in your community.';

  static const String invitationBody =
      'To confirm this signal and become part of the solution, join TOWN as a '
      'verified local member.';

  static const String invitationBodySecond =
      'TOWN is built around real people from the same community — not anonymous '
      'accounts, followers or social media popularity.';

  static const String joinAction = 'Join your community';
  static const String notNowAction = 'Not now';

  static const String joinPlaceholderTitle = 'Join your community';

  static const String joinPlaceholderBody =
      'Account creation, local verification and annual membership will be added '
      'in the next TOWN phase.';

  static const String joinPlaceholderClose = 'Close';

  static const String endedTitle =
      'TOWN is for people who are ready to take part in their community.';

  static const String endedBody =
      'You can return when you are ready to be part of it.';

  static const String leaveTownAction = 'Leave TOWN';
}

/// Membership invitation overlay shown when a visitor taps I SEE THIS TOO.
class VisitorMembershipInvitationPanel extends StatelessWidget {
  const VisitorMembershipInvitationPanel({
    super.key,
    required this.onJoin,
    required this.onNotNow,
  });

  static const Color panel = Color(0xFF141414);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  final VoidCallback onJoin;
  final VoidCallback onNotNow;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double padX = (MediaQuery.sizeOf(context).width * 0.045).clamp(
      16.0,
      21.6,
    );

    return Material(
      key: const Key('visitor_membership_invitation'),
      color: const Color(0x8C000000),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padX + safe.left,
                24,
                padX + safe.right,
                24,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x73000000),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        VisitorCivicCommitmentCopy.invitationTitle,
                        key: Key('visitor_invitation_title'),
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        VisitorCivicCommitmentCopy.invitationBody,
                        key: Key('visitor_invitation_body'),
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        VisitorCivicCommitmentCopy.invitationBodySecond,
                        key: Key('visitor_invitation_body_second'),
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          key: const Key('visitor_join_community'),
                          onPressed: onJoin,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: const Color(0xFF111111),
                            elevation: 0,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          child: const Text(
                            VisitorCivicCommitmentCopy.joinAction,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          key: const Key('visitor_not_now'),
                          onPressed: onNotNow,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ink,
                            side: const BorderSide(
                              color: Color(0x2EFFFFFF),
                              width: 1,
                            ),
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text(
                            VisitorCivicCommitmentCopy.notNowAction,
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
      ),
    );
  }
}

/// Temporary next-phase placeholder after Join your community.
class VisitorJoinPlaceholderPanel extends StatelessWidget {
  const VisitorJoinPlaceholderPanel({super.key, required this.onClose});

  static const Color panel = Color(0xFF141414);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double padX = (MediaQuery.sizeOf(context).width * 0.045).clamp(
      16.0,
      21.6,
    );

    return Material(
      key: const Key('visitor_join_placeholder'),
      color: const Color(0x8C000000),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padX + safe.left,
                24,
                padX + safe.right,
                24,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: panel,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x73000000),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        VisitorCivicCommitmentCopy.joinPlaceholderTitle,
                        key: Key('visitor_join_placeholder_title'),
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        VisitorCivicCommitmentCopy.joinPlaceholderBody,
                        key: Key('visitor_join_placeholder_body'),
                        style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          key: const Key('visitor_join_placeholder_close'),
                          onPressed: onClose,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: const Color(0xFF111111),
                            elevation: 0,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          child: const Text(
                            VisitorCivicCommitmentCopy.joinPlaceholderClose,
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
      ),
    );
  }
}

/// Final exit surface after Not now — no feed, no extra actions.
class VisitorExperienceEndedScreen extends StatelessWidget {
  const VisitorExperienceEndedScreen({super.key, required this.onLeaveTown});

  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  final VoidCallback onLeaveTown;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double padX = (MediaQuery.sizeOf(context).width * 0.045).clamp(
      16.0,
      21.6,
    );

    return Material(
      key: const Key('visitor_experience_ended'),
      color: background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            padX + safe.left,
            40,
            padX + safe.right,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                VisitorCivicCommitmentCopy.endedTitle,
                key: Key('visitor_ended_title'),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                VisitorCivicCommitmentCopy.endedBody,
                key: Key('visitor_ended_body'),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17, height: 1.4, color: inkSoft),
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                child: FilledButton(
                  key: const Key('visitor_leave_town'),
                  onPressed: onLeaveTown,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: const Color(0xFF111111),
                    elevation: 0,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  child: const Text(VisitorCivicCommitmentCopy.leaveTownAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
