tests
testCreateView
	| model controller view |
	model := DCFsmInitialState new.
	(controller := DCFsmInitialStateController new) model: model.
	view := controller view.
	self assert: (view isKindOf: RTElement)