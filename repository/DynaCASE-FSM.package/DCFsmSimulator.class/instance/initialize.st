initialization
initialize
	recognizer := DCFsmRecognizer new.
	recognizer delay: 0.5.
	self watchRecognizer: recognizer.
	super initialize