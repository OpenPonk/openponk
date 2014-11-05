tests
testCreateView
	| model controller view baseController |
	model := DCUmliteClass new.
	(baseController := DCUmliteController new) view: RTView new.
	(controller := DCUmliteClassController new) model: model.
	controller parent: baseController.
	view := controller view.
	self assert: (view isKindOf: RTElement)