private - layout
updatePosition
	| nearestPoints min |
	nearestPoints := self segments
		collect: [ :each | element position nearestPointOnLineFrom: each first to: each second ].
	min := nearestPoints detectMin: [ :each | element position dist: each ].
	gripElement translateTo: min