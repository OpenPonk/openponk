actions
startAction
	input disable.
	startButton disable.
	stopButton enable.
	backButton disable.
	nextButton enable.
	self resetAction.
	recognizer input: input text startingAt: (diagramController model elements detect: #isInitial).
	letterPanel widget data: input text