rendering
resizeBackground
	| bounds |
	bounds := self encompassingRectangle.
"	bounds := bounds merge: (bounds origin corner: self minSize)."
	background translateTo: bounds center.
	background width: self padding x + bounds width + self padding x.
	background height: self padding y + bounds height + self padding y.
	background signalUpdate