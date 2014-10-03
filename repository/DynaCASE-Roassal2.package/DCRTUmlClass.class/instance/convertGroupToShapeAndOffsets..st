private
convertGroupToShapeAndOffsets: aGroup
	| offset shapeAndOffsets |
	offset := 0.
	shapeAndOffsets := OrderedCollection new.
	aGroup
		do: [ :shape | 
			shapeAndOffsets add: (Array with: shape with: 0 @ shape extent y).
			offset := offset + shape extent y ].
	^ shapeAndOffsets