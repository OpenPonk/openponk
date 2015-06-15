accessing
angles
	| a b alpha |
	a := self circle center - from.
	b := self circle center - to.
	alpha := ((a dotProduct: b) / (a r * b r)) arcCos.
	^ {alpha.
	(Float twoPi - alpha)}