private
intersectVertical: other
	"Intersection with other line segment. Self must be vertical (optimization purposes)"

	| pt |
	pt := self transposed intersectHorizontal: other transposed.
	pt ifNil: [ ^ nil ].
	^ pt transposed