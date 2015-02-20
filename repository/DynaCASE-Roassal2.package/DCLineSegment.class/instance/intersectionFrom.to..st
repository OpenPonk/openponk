comparing
intersectionFrom: fromPoint to: toPoint
	"point of intersection with other line segment or nil if it does not exists"

	^ self intersection: (self class from: fromPoint to: toPoint)