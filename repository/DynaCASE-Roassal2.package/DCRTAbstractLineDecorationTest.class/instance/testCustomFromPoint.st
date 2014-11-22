as yet unclassified
testCustomFromPoint
	| head line edge trachelShape |
	head := DCRTLineHead shape: DCRTSimpleArrow.
	line := RTArrowedLine new head: head.
	edge := line edgeFrom: from to: to.
	trachelShape := head trachelShapeFor: edge from: 200 @ 0.
	self assert: (trachelShape from onLineFrom: 105 @ 0 to: 205 @ 0).
	to translateTo: 0 @ -100.
	head updateFor: edge trachelShape: trachelShape from: 0 @ -200.
	self assert: (trachelShape from onLineFrom: 0 @ -105 to: 0 @ -205)