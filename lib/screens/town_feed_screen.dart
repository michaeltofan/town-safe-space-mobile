import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';
import '../widgets/community_signal_card.dart';

/// TOWN Feed V1.1 — full-screen civic reel of Community Signals.
///
/// Exactly three fictional Milano mock scenes. One complete viewport scene
/// per vertical swipe. No permanent Home bar, no bordered outer card shell.
/// No backend, accounts, article, or social mechanics.
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
    // Full available viewport — SafeArea on the scene content preserves
    // notch / home-indicator insets without a fixed footer shell.
    return Scaffold(
      backgroundColor: TownFeedScreen.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              key: const Key('town_feed_page_view'),
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
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
          ],
        ),
      ),
    );
  }
}
