import 'package:flutter/material.dart';

import '../models/town_feed_copy.dart';

/// Temporary visitor civic-commitment surfaces for the feed.
///
/// Visual chrome matches the approved feed panel language.
/// Copy is supplied by [TownFeedCopy] (Italian for Milano, German for Munich).
class VisitorMembershipInvitationPanel extends StatelessWidget {
  const VisitorMembershipInvitationPanel({
    super.key,
    required this.onJoin,
    required this.onNotNow,
    this.copy = const TownFeedCopy.english(),
  });

  static const Color panel = Color(0xFF141414);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  final VoidCallback onJoin;
  final VoidCallback onNotNow;
  final TownFeedCopy copy;

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
                      Text(
                        copy.visitorInvitationTitle,
                        key: const Key('visitor_invitation_title'),
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 24,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        copy.visitorInvitationBody,
                        key: const Key('visitor_invitation_body'),
                        style: const TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          color: inkSoft,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        copy.visitorInvitationBodySecond,
                        key: const Key('visitor_invitation_body_second'),
                        style: const TextStyle(
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
                          child: Text(copy.visitorJoinAction),
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
                          child: Text(copy.visitorNotNowAction),
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
  const VisitorExperienceEndedScreen({
    super.key,
    required this.onLeaveTown,
    this.copy = const TownFeedCopy.english(),
  });

  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  final VoidCallback onLeaveTown;
  final TownFeedCopy copy;

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
              Text(
                copy.visitorEndedTitle,
                key: const Key('visitor_ended_title'),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'serif',
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                copy.visitorEndedBody,
                key: const Key('visitor_ended_body'),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 17, height: 1.4, color: inkSoft),
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
                  child: Text(copy.visitorLeaveTownAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
