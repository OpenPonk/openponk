private
updateSeparator: aSeparator of: content offset: anOffset
	| r |
	r := self encompassingRectangle.
	content value ifNotEmpty: [ aSeparator renderIn: background view ] ifEmpty: [ r := r withRight: r left ].
	group addAll: aSeparator.
	aSeparator
		in: r offset: anOffset + 5;
		update