as yet unclassified
width
	| width |
	width := elements anyOne width.
	elements do: [ :e | width := width max: e width ].
	^ width