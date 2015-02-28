private
updateSeparator: aSeparator of: content offset: anOffset
	| r |
	r := self encompassingRectangle.
	content value size > 0
		ifTrue: [ aSeparator renderIn: background view ]
		ifFalse: [ r := r withRight: r left ].
	group addAll: aSeparator.
	aSeparator
		in: r offset: anOffset + 5;
		update