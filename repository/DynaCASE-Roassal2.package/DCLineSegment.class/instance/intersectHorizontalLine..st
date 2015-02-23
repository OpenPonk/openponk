private
intersectHorizontalLine: other
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Other must be horizontal (optimization purposes)"

	| x y vector |
	vector := self vector.
	vector y isZero
		ifTrue: [ ^ nil ].
	y := other from y.
	x := (other from y - self from y) * self cotan + self from x.
	^ x @ y