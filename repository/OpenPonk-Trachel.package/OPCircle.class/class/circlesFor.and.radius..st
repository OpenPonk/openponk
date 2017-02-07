instance creation
circlesFor: p1 and: p2 radius: r
	^ (self centersFor: p1 and: p2 radius: r) sorted collect: [ :each | self radius: r center: each ]