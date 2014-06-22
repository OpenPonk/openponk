drawing
drawOn: aCanvas
	| outline stroke padding strokeColor |
	padding := 0.
	outline := aCanvas
		createPath: [ :builder | 
			builder
				absolute;
				moveTo: self position;
				relative;
				moveTo: (0 - padding) @ (0 - padding);
				lineTo: (self bounds width + padding + padding) @ 0;
				lineTo: 0 @ (self bounds height + padding + padding);
				lineTo: (0 - self bounds width - padding - padding) @ 0;
				lineTo: 0 @ (0 - self bounds height - padding - padding) ].
	self selected
		ifTrue: [ strokeColor := Color red ]
		ifFalse: [ strokeColor := Color gray ].
	stroke := aCanvas setStrokePaint: strokeColor.
	stroke width: 0.5.
	self selected
		ifFalse: [ stroke dashes: #(5 2) offset: 0 ].
	aCanvas drawShape: outline