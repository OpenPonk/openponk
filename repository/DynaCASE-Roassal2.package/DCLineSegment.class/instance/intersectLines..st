comparing
intersectLines: other
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel"

	| det x y |
	det := self a * other b - (other a * self b).
	det isZero
		ifTrue: [ ^ nil ].
	x := (self b * other c - (other b * self c)) / det.
	y := (other a * self c - (self a * other c)) / det.
	^ x @ y