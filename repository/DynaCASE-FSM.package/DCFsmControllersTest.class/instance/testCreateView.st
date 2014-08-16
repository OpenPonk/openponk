tests
testCreateView
	| controller viewBlock view |
	controller := DCFsmInitialStateController new.
	viewBlock := controller createView.
	self assert: (viewBlock isMemberOf: BlockClosure).
	self assert: viewBlock numArgs = 0.
	view := viewBlock value.
	self assert: (view isKindOf: RTElement).