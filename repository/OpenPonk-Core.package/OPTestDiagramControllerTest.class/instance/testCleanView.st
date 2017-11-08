tests - rebuilding
testCleanView
	| view |
	view := diagramController view.
	view add: RTBox new element.
	self assert: view elements size > 0.
	diagramController cleanView.
	self assert: view elements asArray equals: #().
	self assert: view edges asArray equals: #()