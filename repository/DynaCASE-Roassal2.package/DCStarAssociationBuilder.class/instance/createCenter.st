private
createCenter
	center := RTBox new
		size: 0;
		color: Color transparent;
		element.
	centerDragBox := RTBox new
		size: 10;
		color: Color transparent;
		element.
	TRConstraint stick: center onTheCenterOf: centerDragBox.
	centerDragBox @ RTDraggable.
	self whenCenter: TRMouseDragEnd do: [ self staticCentering ]