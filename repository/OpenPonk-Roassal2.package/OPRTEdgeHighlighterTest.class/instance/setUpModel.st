running
setUpModel
	| endPoint |
	endPoint := RTBox new element.
	view add: endPoint.
	model := RTLine new
		color: Color blue;
		edgeFrom: endPoint to: endPoint.
	view add: model