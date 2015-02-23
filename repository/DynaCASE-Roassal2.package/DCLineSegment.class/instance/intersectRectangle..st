comparing
intersectRectangle: aRectangle
	"collection of points of intersection with not rotated rectangle"

	| pts bottomLeft bottomRight topLeft topRight |
	bottomLeft := aRectangle bottomLeft.
	bottomRight := aRectangle bottomRight.
	topLeft := aRectangle topLeft.
	topRight := aRectangle topRight.
	pts := Set new.
	pts add: (self intersectHorizontal: (self class from: topLeft to: topRight)).
	pts add: (self intersectHorizontal: (self class from: bottomLeft to: bottomRight)).
	pts add: (self intersectVertical: (self class from: topLeft to: bottomLeft)).
	pts add: (self intersectVertical: (self class from: topRight to: bottomRight)).
	pts remove: nil ifAbsent: [  ].
	^ pts