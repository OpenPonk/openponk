private
intersectVerticalLine: other
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Other must be vertical (optimization purposes)"

	| x y vector |
	vector := self vector.
	vector x isZero
		ifTrue: [ ^ nil ].
	x := other from x.
	y := (other from x - self from x) * self tan + self from y.
	^ x @ y