tests
testCreateFigure
	| model controller figure |
	model := DCFsmInitialState new.
	(controller := DCFsmInitialStateController new) model: model.
	figure := controller figure.
	self assert: (figure isKindOf: RTElement)