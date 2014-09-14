as yet unclassified
width
	| width |
	width := 50.
	elements do: [ :e | width := width max: e width ].
	^ width