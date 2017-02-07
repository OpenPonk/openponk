hooks
renderIn: aView
	view := aView.

	mouseBox := RTBox new
		size: 0;
		color: Color transparent;
		element.

	line := lineBuilder value: source value: mouseBox.
"	line shape color: Color veryLightGray."

	mouseBox translateTo: source position.
	aView add: mouseBox.

	aView add: line.
	line update.
	aView signalUpdate.

	moveSubscription := aView announcer
		when: TRMouseMove
		do: [ :event | 
			mouseBox translateTo: event position.
			aView signalUpdate ].

	running := true