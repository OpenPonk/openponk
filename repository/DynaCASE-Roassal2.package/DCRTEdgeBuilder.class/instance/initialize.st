initialization
initialize
	shape := DCRTMultiLine new.
	labels := Dictionary new.
	constraints := Set new.
	self
		rectangleAttachPoint;
		defaultColor