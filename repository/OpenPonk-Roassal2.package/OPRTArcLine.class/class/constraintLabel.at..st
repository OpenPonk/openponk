public
constraintLabel: aLabel at: anArcLine
	aLabel translateTo: (anArcLine shape startingPointOf: anArcLine) + (10 @ 10) + ((aLabel width / 2) @ 0).
	anArcLine from addCallback: (TRTranslationCallback with: aLabel)