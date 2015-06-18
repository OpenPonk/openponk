actions
startAction
	input disable.
	start disable.
	stop enable.
	step enable.
	recognizer model: diagramController model.
	self remainderLabel: input text.
	self symbolLabel: ''.
	recognizer runOn: input text