as yet unclassified
moveAwayFrom: aRectangle via: aVector
	"There should be minDistance between the start and the element. Move it in the direction fo the current segment"

	| vector corners segment |
	"source and target of the edge on top of each other... ignore"
	aVector r = 0
		ifTrue: [ ^ self ].
	vector := aVector normalized * (aRectangle origin dist: aRectangle corner).
	corners := element encompassingRectangle corners
		select: [ :each | aRectangle containsPoint: each ].
	segment := (corners
		collect:
			[ :each | 
			| sg |
			sg := RTLineSegment from: each to: each + vector.
			RTLineSegment from: each to: (sg intersectRectangle: aRectangle) anyOne ])
		detectMax: #length.
	segment ifNotNil: [ element translateBy: segment vector ]
	"	segment
		ifNotNil:
			[ element view
				add:
					(RTSVGPath new
						path:
							'M' , segment from x asString , ',' , segment from y asString , 'L' , segment to x asString
								, ',' , segment to y asString;
						element) ]"