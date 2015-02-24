private
intersectHorizontalLine: other
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Self must be horizontal (optimization purposes)"

	| x y vector |
	vector := other vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	y := self from y.
	x := (self from y - other from y) * other cotan + other from x.
	^ x @ y