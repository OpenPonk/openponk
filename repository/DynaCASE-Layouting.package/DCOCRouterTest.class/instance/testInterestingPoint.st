tests
testInterestingPoint
	| e |
	e := RTBox new
		width: 40;
		height: 20;
		element.
	"
	-30 @ -20 . 0 @ -20 . 30 @ -20.
	-30 @   0 .           30 @   0.
	-30 @  20 . 0 @  20 . 30 @  20."
	self
		assert: (router interestingPointFor: e) asSet
		equals:
			{(-30 @ -20).
			(0 @ -20).
			(30 @ -20).
			(-30 @ 0).
			(30 @ 0).
			(-30 @ 20).
			(0 @ 20).
			(30 @ 20)} asSet