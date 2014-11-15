private
createLineToSelf
	self attachPoint: DCRTToSelfAttachPoint new.
	(blockProducingPath value: 0 @ 0 value: 0 @ 0) size = 2
		ifTrue: [ 
			self
				block: [ :fromPoint :toPoint | 
					| rectangle |
					rectangle := (fromPoint min: toPoint) corner: (fromPoint max: toPoint) + (30 @ 30).
					Array
						with: fromPoint
						with: rectangle topRight
						with: rectangle bottomRight
						with: rectangle bottomLeft
						with: toPoint ] ]