import 'package:flutter/material.dart';

import '../models/community_signal_mock.dart';
import '../widgets/community_signal_card.dart';

/// TOWN Feed — Experience Prototype V1 parity.
///
/// Finite vertical full-bleed civic scenes. No external header, no Home bar,
/// no bordered cards. Session-only confirmation; Open signal placeholder only.
class TownFeedScreen extends StatefulWidget {
  const TownFeedScreen({super.key, this.signals = kMilanoFeedV1MockSignals});

  /// Injected for tests; production uses the three Milano mocks.
  final List<CommunitySignalMock> signals;

  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFE8772E);
  static const Color panel = Color(0xFF141414);
  static const Color ink = Color(0xFFF5F5F5);
  static const Color inkSoft = Color(0xC7F5F5F5);

  static const String openSignalSheetTitle = 'Signal detail';
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
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    assert(
      widget.signals.length == 3,
      'Feed requires exactly 3 Community Signal scenes.',
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
    if (_sheetOpen) {
      return;
    }
    setState(() => _sheetOpen = true);
    try {
      await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: const Color(0x8C000000), // 0.55
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (BuildContext sheetContext) {
          final EdgeInsets safe = MediaQuery.paddingOf(sheetContext);
          final double padX = (MediaQuery.sizeOf(sheetContext).width * 0.045)
              .clamp(16.0, 21.6);
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: TownFeedScreen.panel,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(17.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x73000000),
                      blurRadius: 32,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    padX + safe.left,
                    20,
                    padX + safe.right,
                    17.6 + safe.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        TownFeedScreen.openSignalSheetTitle,
                        key: Key('open_signal_sheet_title'),
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 23.2,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: TownFeedScreen.ink,
                        ),
                      ),
                      const SizedBox(height: 10.4),
                      const Text(
                        TownFeedScreen.openSignalPrototypeMessage,
                        key: Key('open_signal_prototype_message'),
                        style: TextStyle(
                          fontSize: 17.3,
                          height: 1.4,
                          color: TownFeedScreen.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 17.6),
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          key: const Key('open_signal_prototype_close'),
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: TownFeedScreen.accent,
                            foregroundColor: const Color(0xFF111111),
                            elevation: 0,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _sheetOpen = false);
      }
    }
  }

  void _goTo(int index) {
    if (_sheetOpen) {
      return;
    }
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
    return Scaffold(
      backgroundColor: TownFeedScreen.background,
      // Photo extends under system insets; each scene pads its chrome.
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            key: const Key('town_feed_page_view'),
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: _sheetOpen
                ? const NeverScrollableScrollPhysics()
                : const PageScrollPhysics(parent: ClampingScrollPhysics()),
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
                sceneIndex: index + 1,
                sceneCount: widget.signals.length,
                onConfirm: () => _onConfirm(index),
                onOpenSignal: _onOpenSignal,
              );
            },
          ),
          // Assistive next/previous — visually hidden.
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
    );
  }
}
