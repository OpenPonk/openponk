private
intersectVerticalLine: other
	"point of intersection of line on which line segment lies with line of other line segment or nil if parallel. Self must be vertical (optimization purposes)"

	| pt |
	pt := self transposed intersectHorizontalLine: other transposed.
	pt ifNil: [ ^ nil ].
	^ pt transposed