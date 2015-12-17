hook
nodePositionFor: aNode
	| corners |
	corners := (((aNode / #polygon) first attributeAt: #points) splitOn: ' ')
		collect: [ :each | self positionFrom: each ].
	^ (corners min corner: corners max) center