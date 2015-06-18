instance creation
centersFor: p1 and: p2 radius: r
	| d mid sq x y |
	d := p1 dist: p2.
	d > r
		ifTrue: [ self error: 'Points are two far apart.' ].
	mid := (p1 + p2) / 2.
	sq := (r squared - (d / 2) squared) sqrt.
	x := sq * (p2 y - p1 y) / d.
	y := sq * (p2 x - p1 x) / d.

	^ {((mid x + x) @ (mid y - y)).
	((mid x - x) @ (mid y + y))}