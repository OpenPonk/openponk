hooks
transformDistance: distanceAsPoint forElement: anElement
	| d spacing referencePoint |
	spacing := self gridSizeFor: anElement.
	self isSnapDisabled
		ifTrue: [ ^ distanceAsPoint ].
	referencePoint := strategy value: anElement encompassingRectangle.
	d := distanceAsPoint.
	d := d + referencePoint.
	totalDistance := totalDistance + d.
	d := spacing
		* ((totalDistance x / spacing) rounded @ (totalDistance y / spacing) rounded).
	totalDistance := totalDistance - d.
	d := d - referencePoint.
	^ d