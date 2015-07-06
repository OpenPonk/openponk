initialization
initialize
	recognizer := DCFsmNewRecognizer new.
	self watchRecognizer: recognizer.
	super initialize