private - layout
windingOrder: aPoint segment: aSegment
	"A=(x1,y1) to B=(x2,y2) a point P=(x,y)
	d=(x−x1)(y2−y1)−(y−y1)(x2−x1)"

	^ (aPoint x - aSegment first x) * (aSegment second y - aSegment first y)
		- ((aPoint y - aSegment first y) * (aSegment second x - aSegment first x))