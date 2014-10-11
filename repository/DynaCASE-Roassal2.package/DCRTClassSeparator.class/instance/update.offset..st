updating
update: r offset: y
	self first trachelShape translateTo: r left @ (r top + y).
	self second trachelShape translateTo: r right @ (r top + y).
	self third trachelShape pushFront.
	self third update