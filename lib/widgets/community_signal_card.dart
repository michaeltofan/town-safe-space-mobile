import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';

/// Full-screen civic scene for TOWN Feed V1.1.
///
/// One complete viewport scene — not a bordered card inside a page shell.
/// Confirmation state is owned by the parent feed (session-only).
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
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFB8B8B8);
  static const Color soft = Color(0xFF9A9A9A);

  /// Previous Feed V1 compact headline ceiling — V1.1 must stay above this.
  static const double previousCompactHeadlinePx = 18;

  final CommunitySignalMock signal;
  final int confirmationCount;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final VoidCallback onOpenSignal;
  final String positionLabel;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool narrow = size.width < 360;
    final bool short = size.height < 700;
    final bool tiny = size.height < 600;

    // Typographic scale — never crush to force-fit. Prefer shorter copy.
    final double headlineSize = tiny
        ? 22
        : short
        ? 24
        : 26;
    final double summarySize = tiny
        ? 16
        : short
        ? 17.5
        : 19;
    final double authorSize = tiny ? 15.5 : 17;
    final double statusSize = tiny ? 15.5 : 16.5;

    return Semantics(
      container: true,
      label:
          'Community Signal. ${signal.headline}. $positionLabel. Status ${signal.status.label}.',
      child: ColoredBox(
        key: Key('signal_card_surface_${signal.id}'),
        color: const Color(0xFF0A0A0A),
        child: SafeArea(
          // Parent also applies SafeArea; keep bottom/top padding via scene.
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              narrow ? 12 : 14,
              short ? 4 : 6,
              narrow ? 12 : 14,
              short ? 6 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SceneChrome(positionLabel: positionLabel),
                SizedBox(height: tiny ? 10 : 14),
                _AuthorMomentRow(signal: signal, fontSize: authorSize),
                SizedBox(height: tiny ? 8 : 10),
                Text(
                  signal.category,
                  key: Key('signal_category_${signal.id}'),
                  style: TextStyle(
                    color: orange,
                    fontSize: tiny ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: tiny ? 4 : 6),
                Text(
                  signal.headline,
                  key: Key('signal_headline_${signal.id}'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: white,
                    fontSize: headlineSize,
                    fontWeight: FontWeight.w700,
                    height: 1.18,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: tiny ? 4 : 6),
                Text(
                  signal.summary,
                  key: Key('signal_summary_${signal.id}'),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: muted,
                    fontSize: summarySize,
                    height: 1.32,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: tiny ? 10 : 14),
                Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints mediaBox) {
                      return Align(
                        alignment:
                            signal.mediaPresentation ==
                                CivicMediaPresentation.landscape
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        child: _AdaptiveEvidenceMedia(
                          signal: signal,
                          maxWidth: mediaBox.maxWidth,
                          maxHeight: mediaBox.maxHeight,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: tiny ? 10 : 12),
                _LowerCivicZone(
                  signal: signal,
                  confirmationCount: confirmationCount,
                  hasConfirmed: hasConfirmed,
                  onConfirm: onConfirm,
                  onOpenSignal: onOpenSignal,
                  statusSize: statusSize,
                  compact: tiny,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SceneChrome extends StatelessWidget {
  const _SceneChrome({required this.positionLabel});

  final String positionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: _TownWordmark()),
        Semantics(
          liveRegion: true,
          label: 'Card $positionLabel',
          child: Text(
            positionLabel,
            key: const Key('town_feed_position'),
            style: const TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _TownWordmark extends StatelessWidget {
  const _TownWordmark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'TOWN',
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.2,
            color: CommunitySignalCard.white,
          ),
          children: [
            const TextSpan(text: 'T'),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CommunitySignalCard.orange,
                      width: 3.2,
                    ),
                  ),
                ),
              ),
            ),
            const TextSpan(text: 'WN'),
          ],
        ),
      ),
    );
  }
}

/// Status, confirmation, and actions — anchored at the scene bottom.
class _LowerCivicZone extends StatelessWidget {
  const _LowerCivicZone({
    required this.signal,
    required this.confirmationCount,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.onOpenSignal,
    required this.statusSize,
    required this.compact,
  });

  final CommunitySignalMock signal;
  final int confirmationCount;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final VoidCallback onOpenSignal;
  final double statusSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key('signal_lower_civic_zone_${signal.id}'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatusAreaRow(signal: signal, fontSize: statusSize),
        SizedBox(height: compact ? 6 : 8),
        _ConfirmationLine(
          count: confirmationCount,
          signalId: signal.id,
          fontSize: statusSize,
        ),
        SizedBox(height: compact ? 10 : 12),
        _SeeThisTooButton(
          signalId: signal.id,
          hasConfirmed: hasConfirmed,
          onConfirm: onConfirm,
          compact: compact,
        ),
        SizedBox(height: compact ? 4 : 6),
        _OpenSignalButton(
          signalId: signal.id,
          onOpen: onOpenSignal,
          compact: compact,
        ),
      ],
    );
  }
}

/// Dominant civic evidence — near edge-to-edge within scene margins.
class _AdaptiveEvidenceMedia extends StatelessWidget {
  const _AdaptiveEvidenceMedia({
    required this.signal,
    required this.maxWidth,
    required this.maxHeight,
  });

  final CommunitySignalMock signal;
  final double maxWidth;
  final double maxHeight;

  static const double _landscapeSourceAspect = 16 / 9;
  static const double _landscapeMinAspect = 4 / 3;

  @override
  Widget build(BuildContext context) {
    final CivicMediaPresentation presentation = signal.mediaPresentation;
    final Size fitted = _fitForPresentation(
      presentation: presentation,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    return Semantics(
      label:
          'Civic evidence, ${presentation.keyName} photograph for ${signal.placeLabel}',
      child: SizedBox(
        key: Key('signal_media_frame_${signal.id}_${presentation.keyName}'),
        width: fitted.width,
        height: fitted.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            signal.imageAsset,
            key: Key('signal_image_${signal.id}'),
            fit: BoxFit.cover,
            alignment: signal.mediaFocus.alignment,
            filterQuality: FilterQuality.medium,
            width: fitted.width,
            height: fitted.height,
            semanticLabel:
                'Fictional prototype civic evidence image for ${signal.placeLabel}',
          ),
        ),
      ),
    );
  }

  static Size _fitForPresentation({
    required CivicMediaPresentation presentation,
    required double maxWidth,
    required double maxHeight,
  }) {
    if (maxWidth <= 0 || maxHeight <= 0) {
      return Size.zero;
    }

    if (presentation == CivicMediaPresentation.landscape) {
      return _fitLandscape(maxWidth: maxWidth, maxHeight: maxHeight);
    }

    return _fitExact(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: presentation.aspectRatio,
    );
  }

  static Size _fitLandscape({
    required double maxWidth,
    required double maxHeight,
  }) {
    final double width = maxWidth;
    final double naturalHeight = width / _landscapeSourceAspect;
    if (naturalHeight >= maxHeight) {
      return _fitExact(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        aspectRatio: _landscapeSourceAspect,
      );
    }
    final double maxGrowHeight = width / _landscapeMinAspect;
    final double height = math.min(maxHeight, maxGrowHeight);
    return Size(width, height);
  }

  static Size _fitExact({
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
    width = math.min(width, maxWidth);
    height = math.min(height, maxHeight);
    return Size(width, height);
  }
}

class _AuthorMomentRow extends StatelessWidget {
  const _AuthorMomentRow({required this.signal, required this.fontSize});

  final CommunitySignalMock signal;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: signal.authorName,
            style: TextStyle(
              color: CommunitySignalCard.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: '  ·  ',
            style: TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: signal.observedTime,
            style: TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      key: Key('signal_author_${signal.id}'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _StatusAreaRow extends StatelessWidget {
  const _StatusAreaRow({required this.signal, required this.fontSize});

  final CommunitySignalMock signal;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFE8C547),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            signal.status.label,
            key: Key('signal_status_${signal.id}'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CommunitySignalCard.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '  ·  ',
          style: TextStyle(color: CommunitySignalCard.soft, fontSize: fontSize),
        ),
        Flexible(
          child: Text(
            signal.cityZone,
            key: Key('signal_zone_${signal.id}'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CommunitySignalCard.soft,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationLine extends StatelessWidget {
  const _ConfirmationLine({
    required this.count,
    required this.signalId,
    required this.fontSize,
  });

  final int count;
  final String signalId;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        'Confirmed by $count people nearby',
        key: Key('signal_confirmation_$signalId'),
        style: TextStyle(
          color: CommunitySignalCard.muted,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
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
      height: compact ? 48 : 52,
      width: double.infinity,
      child: OutlinedButton(
        key: Key('signal_confirm_$signalId'),
        onPressed: hasConfirmed ? null : onConfirm,
        style: OutlinedButton.styleFrom(
          foregroundColor: CommunitySignalCard.orange,
          disabledForegroundColor: CommunitySignalCard.orange.withValues(
            alpha: 0.85,
          ),
          side: const BorderSide(color: CommunitySignalCard.orange, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Secondary details control — quieter than I SEE THIS TOO; not solid orange.
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
      height: compact ? 40 : 44,
      width: double.infinity,
      child: TextButton(
        key: Key('signal_open_$signalId'),
        onPressed: onOpen,
        style: TextButton.styleFrom(
          foregroundColor: CommunitySignalCard.muted,
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
        child: const Text('Open signal'),
      ),
    );
  }
}
