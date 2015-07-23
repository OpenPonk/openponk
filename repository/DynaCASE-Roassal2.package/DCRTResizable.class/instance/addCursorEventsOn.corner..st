hooks
addCursorEventsOn: anElement corner: aCorner
	anElement when: TRMouseLeave do: [ :evt | World currentHand showTemporaryCursor: nil ].
	anElement when: TRMouseEnter do: [ :evt | World currentHand showTemporaryCursor: (self cursorForCorner: aCorner) ]