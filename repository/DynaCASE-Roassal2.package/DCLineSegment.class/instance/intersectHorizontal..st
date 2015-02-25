private
intersectHorizontal: other
	"Intersection with other line segment. Self must be horizontal (optimization purposes)"

	| pt |
	(pt := self intersectHorizontalLine: other) ifNil: [ ^ nil ].
	pt x < self left x | (pt x > self right x) | (pt y < other bottom y) | (pt y > other top y)
		ifTrue: [ ^ nil ].
	^ pt