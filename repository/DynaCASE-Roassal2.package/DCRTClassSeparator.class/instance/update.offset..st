updating
update: r offset: y
	| delta |
	delta := 5.
	self first trachelShape translateTo: (r left - delta) @ (r top + y).
	self second trachelShape translateTo: (r right + delta) @ (r top + y).
	self third trachelShape pushFront.
	self third update