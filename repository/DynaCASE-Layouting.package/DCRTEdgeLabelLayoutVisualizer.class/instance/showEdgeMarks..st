visualization
showEdgeMarks: aDictionary
	| el line normal normalSeg |
	aDictionary
		keysAndValuesDo:
			[ :edge :set | 
			line := RTLineSegment
				from: (edge shape startingPointOf: edge)
				to: (edge shape endingPointOf: edge).
			set
				do:
					[ :each | 
					normal := 4 * line vector normal.
					normalSeg := RTLineSegment from: each + normal to: each - normal.
					el := RTSVGPath new
						path:
							('M {1} {2} L {3} {4}'
								format:
									{normalSeg from x.
									normalSeg from y.
									normalSeg to x.
									normalSeg to y});
						borderColor: Color red;
						elementOn: each.
					view add: el ] ]