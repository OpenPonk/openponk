tests
testUpdateFromRoassalView
	| roassalView |
	view := OPDiagramView new.
	roassalView := RTView new.
	roassalView canvas camera
		translateTo: 200 @ 27;
		scale: 0.23.
	view updateFromRoassalView: roassalView.
	self assert: view camera offset equals: 200 @ 27.
	self assert: view camera zoom equals: 0.23