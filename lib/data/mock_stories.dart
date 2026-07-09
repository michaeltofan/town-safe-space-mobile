import 'package:flutter/material.dart';

import '../models/local_story.dart';

/// Mock Milano · Brera stories for the visual MVP only.
const List<LocalStory> mockStories = [
  LocalStory(
    id: 'brera-pedestrian',
    locationLabel: 'Milano · Brera',
    headline: 'Should Via Brera become more pedestrian-friendly?',
    summary:
        'A local discussion about traffic, small businesses, tourism pressure, and daily life for residents.',
    authorName: 'Sofia Rinaldi',
    authorBadge: 'Verified Resident',
    dateLabel: 'May 24, 2025',
    readTime: '5 min read',
    body:
        'Via Brera is one of the most iconic streets in Milano. It connects art, culture, small shops and daily life. But in recent years, traffic, delivery vehicles and tourism pressure have changed the balance.\n\n'
        'Residents speak of quieter mornings and safer crossings. Shop owners ask for clearer delivery windows. Visitors still want the atmosphere that made Brera famous.\n\n'
        'This conversation is not about closing the neighborhood. It is about finding a calmer street that still works for the people who live and work here.',
    gradientColors: [
      Color(0xFF3D3228),
      Color(0xFF6B5A48),
      Color(0xFFA89278),
    ],
  ),
  LocalStory(
    id: 'public-spaces',
    locationLabel: 'Milano · Brera',
    headline: 'The future of public spaces in Brera',
    summary: 'New proposals, green areas, and what residents think.',
    authorName: 'Luca Moretti',
    authorBadge: 'Verified Resident',
    dateLabel: 'May 18, 2025',
    readTime: '4 min read',
    body:
        'Brera’s courtyards, piazzas and side streets have always been part of the neighborhood’s quiet rhythm. New proposals now ask how those spaces can stay open, green and useful for residents.\n\n'
        'Some ideas focus on shade and seating. Others look at evening noise, shared courtyards, and small green corners that do not invite overcrowding.\n\n'
        'The question for Brera is simple: how do we keep public space local, calm, and welcoming without turning every corner into a stage?',
    gradientColors: [
      Color(0xFF2F3A32),
      Color(0xFF4F6354),
      Color(0xFF8FA892),
    ],
  ),
  LocalStory(
    id: 'weekend-market',
    locationLabel: 'Milano · Brera',
    headline: 'Weekend market returns near the old quarter',
    summary:
        'Local producers, small businesses, and a calmer Saturday morning for the neighborhood.',
    authorName: 'Elena Conti',
    authorBadge: 'Verified Local Writer',
    dateLabel: 'May 12, 2025',
    readTime: '3 min read',
    body:
        'A weekend market is returning near the old quarter, bringing local producers and small businesses back into the Saturday morning rhythm of Brera.\n\n'
        'Residents remember earlier markets as places to meet neighbors, buy carefully made goods, and start the weekend without rush. Organizers say the new format aims for the same feeling: local, unhurried, and useful.\n\n'
        'If it works, the market may become another quiet civic habit — not an event for crowds, but a morning for the neighborhood.',
    gradientColors: [
      Color(0xFF4A3428),
      Color(0xFF7A5640),
      Color(0xFFC4A07A),
    ],
  ),
];
