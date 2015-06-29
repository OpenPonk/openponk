actions
startAction
	input disable.
	start disable.
	stop enable.
	step enable.
	self resetAction.
	recognizer model: diagramController model.
	self remainderLabel: input text.
	self symbolLabel: ''.
	recognizer runOn: input text