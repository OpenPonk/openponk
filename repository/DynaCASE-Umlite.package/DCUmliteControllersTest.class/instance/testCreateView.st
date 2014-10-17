tests
testCreateView
	| model controller view |
	model := DCUmlClass new.
	(controller := DCUmlClassController new) model: model.
	view := controller view.
	self assert: (view isKindOf: RTElement)