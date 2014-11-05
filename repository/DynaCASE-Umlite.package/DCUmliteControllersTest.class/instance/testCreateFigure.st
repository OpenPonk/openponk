tests
testCreateFigure
	| model controller figure baseController |
	model := DCUmliteClass new.
	(baseController := DCUmliteController new) view: RTView new.
	(controller := DCUmliteClassController new) model: model.
	controller parent: baseController.
	figure := controller figure.
	self assert: (figure isKindOf: RTElement)