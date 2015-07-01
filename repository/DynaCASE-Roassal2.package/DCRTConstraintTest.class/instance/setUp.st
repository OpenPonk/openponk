running
setUp
	true ifTrue: [ ^ self skip ].
	box1 := RTBox element translateTo: 0 @ 0.
	box2 := RTBox element translateTo: 100 @ 0.
	edge := RTLine edgeFrom: box1 to: box2.
	shape1 := RTBox element translateTo: 50 @ 0.
	shape2 := RTBox element translateTo: 0 @ 10.
	shape3 := RTBox element translateTo: -50 @ -10