comparing
intersectRectangle: aRectangle
	"collection of points of intersection with not rotated rectangle"

	| pts bottomLeft bottomRight topLeft topRight |
	bottomLeft := aRectangle bottomLeft.
	bottomRight := aRectangle bottomRight.
	topLeft := aRectangle topLeft.
	topRight := aRectangle topRight.
	pts := Set new.
	pts add: ((self class from: topLeft to: topRight) intersectHorizontal: self).
	pts add: ((self class from: bottomLeft to: bottomRight) intersectHorizontal: self).
	pts add: ((self class from: topLeft to: bottomLeft) intersectVertical: self).
	pts add: ((self class from: topRight to: bottomRight) intersectVertical: self).
	pts remove: nil ifAbsent: [  ].
	^ pts