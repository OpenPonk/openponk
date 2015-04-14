tests
testHead
	| head line edge trachelShape |
	head := DCRTLineHead shape: DCRTSimpleArrow.
	line := RTArrowedLine new head: head.
	edge := line edgeFrom: from to: to.

	trachelShape := head trachelShapeFor: edge.
	self assert: trachelShape to = (100 @ 0).

	to translateTo: 0 @ -100.
	head updateFor: edge trachelShape: trachelShape.
	self assert: trachelShape to = (0 @ -100)