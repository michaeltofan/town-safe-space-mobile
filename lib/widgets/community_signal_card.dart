import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';

/// Reusable COMMUNITY SIGNAL card for TOWN Feed V1.
///
/// Renders one full viewport card without internal scrolling.
/// Media height adapts to [CivicMediaPresentation] — landscape, portrait, or
/// square — while preserving source aspect ratio (never stretched).
class CommunitySignalCard extends StatelessWidget {
  const CommunitySignalCard({
    super.key,
    required this.signal,
    required this.confirmationCount,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.onOpenSignal,
    required this.positionLabel,
  });

  static const Color orange = Color(0xFFFF5A1F);
  static const Color cardBg = Color(0xFF161616);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFB5B5B5);
  static const Color soft = Color(0xFF8E8E8E);

  final CommunitySignalMock signal;
  final int confirmationCount;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final VoidCallback onOpenSignal;
  final String positionLabel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool compact = size.height < 700;
    final bool tiny = size.height < 600 || size.width < 340;

    return Semantics(
      container: true,
      label:
          'Community Signal. ${signal.headline}. $positionLabel. Status ${signal.status.label}.',
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          tiny ? 8 : 10,
          tiny ? 2 : 4,
          tiny ? 8 : 10,
          tiny ? 2 : 4,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              tiny ? 10 : 12,
              tiny ? 8 : 10,
              tiny ? 10 : 12,
              tiny ? 8 : 10,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double mediaBudget = _mediaHeightBudget(
                  viewportHeight: size.height,
                  presentation: signal.mediaPresentation,
                  tiny: tiny,
                  compact: compact,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AuthorRow(signal: signal, compact: compact || tiny),
                    SizedBox(
                      height: tiny
                          ? 5
                          : compact
                          ? 6
                          : 8,
                    ),
                    Text(
                      signal.category,
                      key: Key('signal_category_${signal.id}'),
                      style: TextStyle(
                        color: orange,
                        fontSize: tiny
                            ? 10.5
                            : compact
                            ? 11
                            : 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: tiny ? 2 : 4),
                    Text(
                      signal.headline,
                      key: Key('signal_headline_${signal.id}'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: white,
                        fontSize: tiny
                            ? 15
                            : compact
                            ? 16.5
                            : 18,
                        fontWeight: FontWeight.w700,
                        height: 1.18,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: tiny ? 2 : 4),
                    Text(
                      signal.summary,
                      key: Key('signal_summary_${signal.id}'),
                      maxLines: tiny
                          ? 2
                          : compact
                          ? 2
                          : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: muted,
                        fontSize: tiny
                            ? 11.5
                            : compact
                            ? 12.5
                            : 13.5,
                        height: 1.28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: tiny ? 6 : 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints mediaBox) {
                              final double available = mediaBox.maxHeight;
                              final double maxH = available.isFinite
                                  ? math.min(mediaBudget, available)
                                  : mediaBudget;
                              return Align(
                                alignment: Alignment.topCenter,
                                // Shrink-wrap to the media — do not expand and
                                // create dead space between image and status.
                                widthFactor: 1,
                                heightFactor: 1,
                                child: _AdaptiveEvidenceMedia(
                                  signal: signal,
                                  maxWidth: constraints.maxWidth,
                                  maxHeight: maxH,
                                ),
                              );
                            },
                      ),
                    ),
                    SizedBox(height: tiny ? 6 : 8),
                    _StatusRow(signal: signal, compact: compact || tiny),
                    SizedBox(height: tiny ? 4 : 6),
                    _ConfirmationLine(
                      count: confirmationCount,
                      signalId: signal.id,
                    ),
                    SizedBox(height: tiny ? 6 : 8),
                    _SeeThisTooButton(
                      signalId: signal.id,
                      hasConfirmed: hasConfirmed,
                      onConfirm: onConfirm,
                      compact: compact || tiny,
                    ),
                    SizedBox(height: tiny ? 4 : 6),
                    _OpenSignalButton(
                      signalId: signal.id,
                      onOpen: onOpenSignal,
                      compact: compact || tiny,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Bounded responsive media budget by presentation mode.
  /// Portrait receives more vertical height; landscape stays moderate.
  static double _mediaHeightBudget({
    required double viewportHeight,
    required CivicMediaPresentation presentation,
    required bool tiny,
    required bool compact,
  }) {
    final double fraction = switch (presentation) {
      CivicMediaPresentation.landscape =>
        tiny
            ? 0.20
            : compact
            ? 0.23
            : 0.26,
      CivicMediaPresentation.portrait =>
        tiny
            ? 0.28
            : compact
            ? 0.32
            : 0.36,
      CivicMediaPresentation.square =>
        tiny
            ? 0.24
            : compact
            ? 0.27
            : 0.30,
    };
    return viewportHeight * fraction;
  }
}

/// Sizes civic evidence to the declared presentation aspect without stretching.
class _AdaptiveEvidenceMedia extends StatelessWidget {
  const _AdaptiveEvidenceMedia({
    required this.signal,
    required this.maxWidth,
    required this.maxHeight,
  });

  final CommunitySignalMock signal;
  final double maxWidth;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final CivicMediaPresentation presentation = signal.mediaPresentation;
    final double aspect = presentation.aspectRatio;
    final Size fitted = _fitWithin(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspect,
    );

    return Semantics(
      label:
          'Civic evidence, ${presentation.keyName} photograph for ${signal.placeLabel}',
      child: SizedBox(
        key: Key('signal_media_frame_${signal.id}_${presentation.keyName}'),
        width: fitted.width,
        height: fitted.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                signal.imageAsset,
                key: Key('signal_image_${signal.id}'),
                fit: BoxFit.cover,
                alignment: signal.mediaFocus.alignment,
                // Cover fills the aspect-matched frame without stretching.
                filterQuality: FilterQuality.medium,
                semanticLabel:
                    'Fictional prototype civic evidence image for ${signal.placeLabel}',
              ),
              Positioned(
                left: 8,
                bottom: 8,
                right: 8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xCC111111),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: CommunitySignalCard.white,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              signal.placeLabel,
                              key: Key('signal_place_${signal.id}'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: CommunitySignalCard.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fit [aspectRatio] (width/height) inside bounds without stretching.
  static Size _fitWithin({
    required double maxWidth,
    required double maxHeight,
    required double aspectRatio,
  }) {
    double width = maxWidth;
    double height = width / aspectRatio;
    if (height > maxHeight) {
      height = maxHeight;
      width = height * aspectRatio;
    }
    return Size(width, height);
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.signal, required this.compact});

  final CommunitySignalMock signal;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String initials = signal.authorName.trim().isEmpty
        ? '?'
        : signal.authorName
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((String p) => p[0].toUpperCase())
              .join();

    return Row(
      children: [
        CircleAvatar(
          radius: compact ? 13 : 15,
          backgroundColor: const Color(0xFF2C2C2C),
          child: Text(
            initials,
            style: TextStyle(
              color: CommunitySignalCard.white,
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signal.authorName,
                key: Key('signal_author_${signal.id}'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CommunitySignalCard.white,
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${signal.localRelationship} · ${signal.cityZone}',
                key: Key('signal_meta_${signal.id}'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: CommunitySignalCard.soft,
                  fontSize: compact ? 11 : 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            signal.observedTime,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: compact ? 10.5 : 11.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.signal, required this.compact});

  final CommunitySignalMock signal;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 10,
                vertical: compact ? 4 : 5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8C547),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      signal.status.label,
                      key: Key('signal_status_${signal.id}'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CommunitySignalCard.white,
                        fontSize: compact ? 11 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            signal.cityZone,
            key: Key('signal_zone_${signal.id}'),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: compact ? 11 : 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationLine extends StatelessWidget {
  const _ConfirmationLine({required this.count, required this.signalId});

  final int count;
  final String signalId;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        children: [
          const Icon(
            Icons.groups_outlined,
            size: 16,
            color: CommunitySignalCard.muted,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Confirmed by $count people nearby',
              key: Key('signal_confirmation_$signalId'),
              style: const TextStyle(
                color: CommunitySignalCard.muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeeThisTooButton extends StatelessWidget {
  const _SeeThisTooButton({
    required this.signalId,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.compact,
  });

  final String signalId;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String label = hasConfirmed
        ? 'You confirmed this locally'
        : 'I SEE THIS TOO';

    return SizedBox(
      height: compact ? 42 : 46,
      width: double.infinity,
      child: OutlinedButton(
        key: Key('signal_confirm_$signalId'),
        onPressed: hasConfirmed ? null : onConfirm,
        style: OutlinedButton.styleFrom(
          foregroundColor: CommunitySignalCard.orange,
          disabledForegroundColor: CommunitySignalCard.orange.withValues(
            alpha: 0.85,
          ),
          side: const BorderSide(color: CommunitySignalCard.orange, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _OpenSignalButton extends StatelessWidget {
  const _OpenSignalButton({
    required this.signalId,
    required this.onOpen,
    required this.compact,
  });

  final String signalId;
  final VoidCallback onOpen;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 42 : 46,
      width: double.infinity,
      child: FilledButton(
        key: Key('signal_open_$signalId'),
        onPressed: onOpen,
        style: FilledButton.styleFrom(
          backgroundColor: CommunitySignalCard.orange,
          foregroundColor: const Color(0xFF111111),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        child: const Text('Open signal'),
      ),
    );
  }
}
