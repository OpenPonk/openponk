drawing
drawOn: aCanvas
	super drawOn: aCanvas.
	aCanvas pathTransform
		restoreAfter: [ 
			aCanvas pathTransform translateX: self position x Y: self position y + self font getPreciseAscent.
			aCanvas
				setPaint: self textColor;
				setFont: self font.
			aCanvas drawString: self text ]