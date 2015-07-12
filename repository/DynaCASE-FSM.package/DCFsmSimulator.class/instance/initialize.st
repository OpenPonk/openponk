initialization
initialize
	recognizer := DCFsmRecognizer new.
	self watchRecognizer: recognizer.
	super initialize