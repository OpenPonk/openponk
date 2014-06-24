drawing
drawOn: aCanvas
	| nameCentering |
	super drawOn: aCanvas.
	self borderCircle
		position: self position;
		drawOn: aCanvas.
	nameCentering := (self borderCircle width - self name width) / 2.
	self name
		position: (self position x + nameCentering) @ (self position y + (self height / 2) - name font getPreciseAscent)