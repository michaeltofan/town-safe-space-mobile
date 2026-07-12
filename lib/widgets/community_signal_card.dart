import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';

/// Full-bleed civic scene matching Experience Prototype V1.
///
/// Layout mirrors `.scene` / `.scene-chrome`:
/// photo cover → veil → top brand/pager → body text → actions.
class CommunitySignalCard extends StatelessWidget {
  const CommunitySignalCard({
    super.key,
    required this.signal,
    required this.confirmationCount,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.onOpenSignal,
    required this.positionLabel,
    required this.sceneIndex,
    required this.sceneCount,
  });

  static const Color accent = Color(0xFFE8772E);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5); // ~0.78
  static const Color inkMute = Color(0x94F5F5F5); // ~0.58
  static const Color statusDot = Color(0xFFF0C419);

  final CommunitySignalMock signal;
  final int confirmationCount;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final VoidCallback onOpenSignal;
  final String positionLabel;
  final int sceneIndex;
  final int sceneCount;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final bool short = size.height < 700;
    final bool narrow = size.width <= 360;

    final double padX = (size.width * 0.045).clamp(16.0, 21.6);
    final double topPad = 11.2 + safe.top;
    final double bottomPad = 13.6 + safe.bottom;
    final double gap = short ? 5.6 : 8.8;
    final double actionGap = short ? 5.6 : 7.2;
    final double btnMinHeight = short ? 44.0 : 48.0;
    final double btnPadV = short ? 11.2 : 13.6;

    // CSS clamp(min, preferred vw, max) with rem=16.
    double brandSize = (size.width * 0.034).clamp(16.8, 19.2);
    const double pagerSize = 15.2;
    double metaSize = (size.width * 0.028).clamp(16.8, 19.2);
    double categorySize = (size.width * 0.022).clamp(12.5, 14.1);
    double headlineSize = (size.width * 0.058).clamp(30.0, 40.8);
    double summarySize = (size.width * 0.032).clamp(18.0, 21.6);
    if (short) {
      headlineSize = (size.width * 0.054).clamp(27.2, 33.6);
      summarySize = (size.width * 0.03).clamp(16.8, 19.2);
      metaSize = math.min(metaSize, 16.8);
    }
    if (narrow) {
      headlineSize = math.min(headlineSize, 27.2);
      summarySize = math.min(summarySize, 16.8);
    }
    // Extra compression for very short phones (prototype still shows full copy).
    if (size.height <= 600) {
      headlineSize = math.min(headlineSize, 22.0);
      summarySize = math.min(summarySize, 14.5);
      metaSize = math.min(metaSize, 14.0);
      categorySize = math.min(categorySize, 11.0);
      brandSize = math.min(brandSize, 16.0);
    }

    final double statusSize = (size.width * 0.028).clamp(
      size.height <= 600 ? 13.0 : 16.0,
      18.4,
    );
    final double countSize = (size.width * 0.026).clamp(
      size.height <= 600 ? 12.5 : 15.7,
      17.9,
    );
    final double btnSize = (size.width * 0.03).clamp(
      size.height <= 600 ? 13.5 : 16.0,
      17.9,
    );
    final double confirmedBtnSize = math.min(btnSize, 16.8);

    return Semantics(
      container: true,
      label:
          'Community Signal. ${signal.headline}. $positionLabel. '
          'Status ${signal.status.label}.',
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: const Color(0xFF111111),
              child: Image.asset(
                signal.imageAsset,
                key: Key('signal_image_${signal.id}'),
                fit: BoxFit.cover,
                alignment: signal.mediaFocus,
                filterQuality: FilterQuality.high,
                semanticLabel: 'Civic evidence photograph for ${signal.area}',
              ),
            ),
            const DecoratedBox(
              key: Key('scene_veil'),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xB8000000),
                    Color(0x47000000),
                    Color(0x2E000000),
                    Color(0x8C000000),
                    Color(0xE0000000),
                  ],
                  stops: [0.0, 0.28, 0.48, 0.72, 1.0],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                padX + safe.left,
                topPad,
                padX + safe.right,
                bottomPad,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SceneTop(
                    brandSize: brandSize,
                    pagerSize: pagerSize,
                    sceneIndex: sceneIndex,
                    sceneCount: sceneCount,
                  ),
                  SizedBox(height: gap),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints bodyBox) {
                        return Align(
                          alignment: Alignment.bottomLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: bodyBox.maxWidth,
                              maxHeight: bodyBox.maxHeight,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                width: bodyBox.maxWidth,
                                child: _SceneBody(
                                  signal: signal,
                                  metaSize: metaSize,
                                  categorySize: categorySize,
                                  headlineSize: headlineSize,
                                  summarySize: summarySize,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: gap),
                  _SceneActions(
                    signal: signal,
                    confirmationCount: confirmationCount,
                    hasConfirmed: hasConfirmed,
                    onConfirm: onConfirm,
                    onOpenSignal: onOpenSignal,
                    actionGap: actionGap,
                    statusSize: statusSize,
                    countSize: countSize,
                    btnSize: btnSize,
                    confirmedBtnSize: confirmedBtnSize,
                    btnMinHeight: btnMinHeight,
                    btnPadV: btnPadV,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneTop extends StatelessWidget {
  const _SceneTop({
    required this.brandSize,
    required this.pagerSize,
    required this.sceneIndex,
    required this.sceneCount,
  });

  final double brandSize;
  final double pagerSize;
  final int sceneIndex;
  final int sceneCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            'TOWN',
            key: const Key('scene_brand'),
            style: TextStyle(
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.w800,
              letterSpacing: brandSize * 0.08,
              fontSize: brandSize,
              height: 1,
              color: CommunitySignalCard.ink,
            ),
          ),
        ),
        Semantics(
          liveRegion: true,
          label: 'Card $sceneIndex / $sceneCount',
          child: Text(
            '$sceneIndex / $sceneCount',
            key: const Key('town_feed_position'),
            style: TextStyle(
              fontSize: pagerSize,
              color: CommunitySignalCard.inkMute,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _SceneBody extends StatelessWidget {
  const _SceneBody({
    required this.signal,
    required this.metaSize,
    required this.categorySize,
    required this.headlineSize,
    required this.summarySize,
  });

  final CommunitySignalMock signal;
  final double metaSize;
  final double categorySize;
  final double headlineSize;
  final double summarySize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          signal.metaLine,
          key: Key('signal_meta_${signal.id}'),
          style: TextStyle(
            fontSize: metaSize,
            height: 1.25,
            fontWeight: FontWeight.w500,
            color: CommunitySignalCard.inkSoft,
          ),
        ),
        SizedBox(height: metaSize * 0.45),
        Text(
          signal.category,
          key: Key('signal_category_${signal.id}'),
          style: TextStyle(
            fontSize: categorySize,
            letterSpacing: categorySize * 0.12,
            fontWeight: FontWeight.w700,
            color: const Color(0xEBE8772E),
          ),
        ),
        SizedBox(height: categorySize * 0.45),
        Text(
          signal.headline,
          key: Key('signal_headline_${signal.id}'),
          style: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.w700,
            fontSize: headlineSize,
            height: 1.08,
            letterSpacing: -0.015 * headlineSize,
            color: CommunitySignalCard.ink,
            shadows: const [Shadow(color: Color(0x59000000), blurRadius: 18)],
          ),
        ),
        SizedBox(height: headlineSize * 0.18),
        Text(
          signal.summary,
          key: Key('signal_summary_${signal.id}'),
          style: TextStyle(
            fontSize: summarySize,
            height: 1.35,
            color: CommunitySignalCard.inkSoft,
            shadows: const [Shadow(color: Color(0x4D000000), blurRadius: 12)],
          ),
        ),
      ],
    );
  }
}

class _SceneActions extends StatelessWidget {
  const _SceneActions({
    required this.signal,
    required this.confirmationCount,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.onOpenSignal,
    required this.actionGap,
    required this.statusSize,
    required this.countSize,
    required this.btnSize,
    required this.confirmedBtnSize,
    required this.btnMinHeight,
    required this.btnPadV,
  });

  final CommunitySignalMock signal;
  final int confirmationCount;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final VoidCallback onOpenSignal;
  final double actionGap;
  final double statusSize;
  final double countSize;
  final double btnSize;
  final double confirmedBtnSize;
  final double btnMinHeight;
  final double btnPadV;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key('signal_lower_civic_zone_${signal.id}'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5.6,
          children: [
            Container(
              width: math.max(7.0, statusSize * 0.55),
              height: math.max(7.0, statusSize * 0.55),
              decoration: const BoxDecoration(
                color: CommunitySignalCard.statusDot,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              signal.status.label,
              key: Key('signal_status_${signal.id}'),
              style: TextStyle(
                fontSize: statusSize,
                height: 1.25,
                fontWeight: FontWeight.w600,
                color: CommunitySignalCard.ink,
              ),
            ),
            Text(
              '·',
              style: TextStyle(
                fontSize: statusSize,
                color: CommunitySignalCard.inkMute,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              signal.area,
              key: Key('signal_zone_${signal.id}'),
              style: TextStyle(
                fontSize: statusSize,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: CommunitySignalCard.inkMute,
              ),
            ),
          ],
        ),
        SizedBox(height: actionGap),
        Semantics(
          liveRegion: true,
          child: Text(
            'Confirmed by $confirmationCount people nearby',
            key: Key('signal_confirmation_${signal.id}'),
            style: TextStyle(
              fontSize: countSize,
              height: 1.25,
              color: CommunitySignalCard.inkMute,
            ),
          ),
        ),
        SizedBox(height: actionGap + 3.2),
        _ConfirmButton(
          signalId: signal.id,
          hasConfirmed: hasConfirmed,
          onConfirm: onConfirm,
          btnSize: hasConfirmed ? confirmedBtnSize : btnSize,
          btnMinHeight: btnMinHeight,
          btnPadV: btnPadV,
        ),
        SizedBox(height: actionGap),
        _OpenSignalButton(
          signalId: signal.id,
          onOpen: onOpenSignal,
          btnSize: btnSize,
          btnMinHeight: btnMinHeight,
          btnPadV: btnPadV,
        ),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({
    required this.signalId,
    required this.hasConfirmed,
    required this.onConfirm,
    required this.btnSize,
    required this.btnMinHeight,
    required this.btnPadV,
  });

  final String signalId;
  final bool hasConfirmed;
  final VoidCallback onConfirm;
  final double btnSize;
  final double btnMinHeight;
  final double btnPadV;

  @override
  Widget build(BuildContext context) {
    final String label = hasConfirmed
        ? 'You confirmed this locally'
        : 'I SEE THIS TOO';

    return SizedBox(
      width: double.infinity,
      height: btnMinHeight,
      child: OutlinedButton(
        key: Key('signal_confirm_$signalId'),
        onPressed: hasConfirmed ? null : onConfirm,
        style: OutlinedButton.styleFrom(
          foregroundColor: CommunitySignalCard.accent,
          disabledForegroundColor: CommunitySignalCard.accent,
          backgroundColor: hasConfirmed
              ? const Color(0x1AE8772E)
              : Colors.transparent,
          disabledBackgroundColor: const Color(0x1AE8772E),
          side: const BorderSide(color: CommunitySignalCard.accent, width: 1.5),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: btnPadV * 0.2,
          ),
          minimumSize: Size(0, btnMinHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: btnSize,
            fontWeight: FontWeight.w700,
            letterSpacing: hasConfirmed ? 0.02 * btnSize : 0.04 * btnSize,
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

class _OpenSignalButton extends StatelessWidget {
  const _OpenSignalButton({
    required this.signalId,
    required this.onOpen,
    required this.btnSize,
    required this.btnMinHeight,
    required this.btnPadV,
  });

  final String signalId;
  final VoidCallback onOpen;
  final double btnSize;
  final double btnMinHeight;
  final double btnPadV;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: btnMinHeight,
      child: OutlinedButton(
        key: Key('signal_open_$signalId'),
        onPressed: onOpen,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xE0F5F5F5),
          backgroundColor: const Color(0x8C141414),
          side: const BorderSide(color: Color(0x2EFFFFFF), width: 1),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: btnPadV * 0.2,
          ),
          minimumSize: Size(0, btnMinHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: btnSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.01 * btnSize,
          ),
        ),
        child: const Text('Open signal', textAlign: TextAlign.center),
      ),
    );
  }
}
