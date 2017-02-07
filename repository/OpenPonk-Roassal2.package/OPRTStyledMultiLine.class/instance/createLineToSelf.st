private
createLineToSelf
	"changes path to display itself from one element to the same one"

	self attachPoint: OPRTOrthogonalSelfAttachPoint new.
	(blockProducingPath value: 0 @ 0 value: 0 @ 0) size = 2
		ifTrue: [ 
			self
				block: [ :fromPoint :toPoint | 
					| rectangle |
					rectangle := Rectangle
						origin: (fromPoint min: toPoint)
						extent: 2 * ((fromPoint max: toPoint) - (fromPoint min: toPoint)) + (12 @ 12).
					Array
						with: fromPoint
						with: rectangle topRight
						with: rectangle bottomRight
						with: rectangle bottomLeft
						with: toPoint ] ]