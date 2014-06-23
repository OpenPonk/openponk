adding
addPoint: aPoint
	| pHandle |
	pHandle := DCVisualCircle new
		radius: 15;
		center: aPoint;
		container: self.
	self addNode: pHandle.
	self pointHandles add: pHandle.
	self resetBounds