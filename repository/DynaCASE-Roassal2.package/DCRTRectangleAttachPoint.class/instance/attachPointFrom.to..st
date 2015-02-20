as yet unclassified
attachPointFrom: fromElement to: toElement
	| rectangle fromPos toPos line topLeft topRight bottomLeft bottomRight intersection |
	rectangle := fromElement encompassingRectangle flipBy: #vertical centerAt: 0 @ 0.
	topLeft := rectangle topLeft.
	topRight := rectangle topRight.
	bottomLeft := rectangle bottomLeft.
	bottomRight := rectangle bottomRight.
	fromPos := fromElement position.
	toPos := toElement position.
	line := DCLineSegment from: fromPos x @ fromPos y negated to: toPos x @ toPos y negated.
	intersection := line intersectionFrom: topLeft to: topRight.
	intersection
		ifNil: [ 
			intersection := line intersectionFrom: bottomLeft to: bottomRight.
			intersection
				ifNil: [ 
					intersection := line intersectionFrom: topLeft to: bottomLeft.
					intersection
						ifNil: [ 
							intersection := line intersectionFrom: topRight to: bottomRight.
							intersection ifNil: [ ^ fromPos ] ] ] ].
	^ intersection x @ intersection y negated