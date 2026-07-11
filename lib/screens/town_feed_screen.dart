import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';
import '../widgets/community_signal_card.dart';

/// TOWN Feed V1 — finite vertical Community Signal prototype.
///
/// Exactly three fictional Milano mock cards. No backend, accounts, article,
/// or social mechanics.
class TownFeedScreen extends StatefulWidget {
  const TownFeedScreen({super.key, this.signals = kMilanoFeedV1MockSignals});

  /// Injected for tests; production uses the three Milano mocks.
  final List<CommunitySignalMock> signals;

  static const Color background = Color(0xFF0A0A0A);
  static const Color orange = Color(0xFFFF5A1F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9A9A9A);

  static const String openSignalPrototypeMessage =
      'Signal details will be added in the next TOWN phase.';

  @override
  State<TownFeedScreen> createState() => _TownFeedScreenState();
}

class _TownFeedScreenState extends State<TownFeedScreen> {
  late final PageController _pageController;
  late final List<int> _confirmationCounts;
  late final List<bool> _confirmed;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    assert(
      widget.signals.length == 3,
      'Feed V1 requires exactly 3 Community Signal cards.',
    );
    _pageController = PageController();
    _confirmationCounts = widget.signals
        .map((CommunitySignalMock s) => s.initialConfirmationCount)
        .toList(growable: false);
    _confirmed = List<bool>.filled(widget.signals.length, false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onConfirm(int index) {
    if (_confirmed[index]) {
      return;
    }
    setState(() {
      _confirmed[index] = true;
      _confirmationCounts[index] = _confirmationCounts[index] + 1;
    });
  }

  Future<void> _onOpenSignal() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  TownFeedScreen.openSignalPrototypeMessage,
                  key: Key('open_signal_prototype_message'),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TownFeedScreen.white,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    key: const Key('open_signal_prototype_close'),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: TownFeedScreen.orange,
                      foregroundColor: const Color(0xFF111111),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.signals.length) {
      return;
    }
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    _pageController.animateToPage(
      index,
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String positionLabel = '${_index + 1} / ${widget.signals.length}';

    return Scaffold(
      backgroundColor: TownFeedScreen.background,
      body: SafeArea(
        child: Column(
          children: [
            _TownFeedHeader(positionLabel: positionLabel),
            Expanded(
              child: Semantics(
                explicitChildNodes: true,
                child: PageView.builder(
                  key: const Key('town_feed_page_view'),
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const PageScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemCount: widget.signals.length,
                  onPageChanged: (int value) {
                    setState(() => _index = value);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final CommunitySignalMock signal = widget.signals[index];
                    return CommunitySignalCard(
                      key: Key('town_feed_card_$index'),
                      signal: signal,
                      confirmationCount: _confirmationCounts[index],
                      hasConfirmed: _confirmed[index],
                      positionLabel: '${index + 1} / ${widget.signals.length}',
                      onConfirm: () => _onConfirm(index),
                      onOpenSignal: _onOpenSignal,
                    );
                  },
                ),
              ),
            ),
            // Quiet next/previous for assistive access — visually restrained.
            Offstage(
              offstage: true,
              child: Row(
                children: [
                  TextButton(
                    key: const Key('town_feed_a11y_previous'),
                    onPressed: () => _goTo(_index - 1),
                    child: const Text('Previous signal'),
                  ),
                  TextButton(
                    key: const Key('town_feed_a11y_next'),
                    onPressed: () => _goTo(_index + 1),
                    child: const Text('Next signal'),
                  ),
                ],
              ),
            ),
            const _TownFeedBottomShell(),
          ],
        ),
      ),
    );
  }
}

class _TownFeedHeader extends StatelessWidget {
  const _TownFeedHeader({required this.positionLabel});

  final String positionLabel;

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).height < 640;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, compact ? 4 : 6, 18, compact ? 2 : 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: _TownWordmark()),
              Semantics(
                liveRegion: true,
                label: 'Card $positionLabel',
                child: Text(
                  positionLabel,
                  key: const Key('town_feed_position'),
                  style: TextStyle(
                    color: TownFeedScreen.muted,
                    fontSize: compact ? 11 : 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 6 : 10),
          const Text(
            'Milano · Community Signals',
            key: Key('town_feed_city_context'),
            style: TextStyle(
              color: TownFeedScreen.muted,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
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
            color: TownFeedScreen.white,
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
                      color: TownFeedScreen.orange,
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

/// Minimal Feed V1 shell: Home is the only destination shown.
/// Unfinished destinations are omitted so they cannot look interactive.
class _TownFeedBottomShell extends StatelessWidget {
  const _TownFeedBottomShell();

  @override
  Widget build(BuildContext context) {
    final bool compact = MediaQuery.sizeOf(context).height < 640;

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF222222))),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, compact ? 6 : 8, 16, compact ? 6 : 8),
        child: Row(
          key: const Key('town_feed_home_shell'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_rounded,
              size: compact ? 18 : 20,
              color: TownFeedScreen.orange,
            ),
            const SizedBox(width: 8),
            Text(
              'Home',
              key: const Key('town_feed_home_label'),
              style: TextStyle(
                color: TownFeedScreen.orange,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
