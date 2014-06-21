drawing
drawOn: aCanvas
	| outline stroke padding |
	padding := 5.
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
	stroke := aCanvas setStrokePaint: Color red.
	stroke width: 0.5.
	stroke dashes: #(5 2) offset: 0.
	aCanvas drawShape: outline