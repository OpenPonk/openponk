private
intersectHorizontal: other
	"Intersection with other line segment. Other must be horizontal (optimization purposes)"

	| pt |
	pt := self intersectHorizontalLine: other.
	pt ifNil: [ ^ nil ].
	pt x < other left x | (pt x > other right x) | (pt y < self bottom y) | (pt y > self top y)
		ifTrue: [ ^ nil ].
	^ pt