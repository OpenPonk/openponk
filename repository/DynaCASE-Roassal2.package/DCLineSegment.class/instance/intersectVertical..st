private
intersectVertical: other
	"Intersection with other line segment. Other must be vertical (optimization purposes)"

	| pt |
	pt := self intersectVerticalLine: other.
	pt ifNil: [ ^ nil ].
	pt x < self left x | (pt x > self right x) | (pt y < other bottom y) | (pt y > other top y)
		ifTrue: [ ^ nil ].
	^ pt