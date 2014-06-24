initialization
initializePresenter
	| element |
	circleButton
		action: [ 
			(element := DCVisualCircle new) radius: 20.
			self onAction value: element ].
	ellipseButton
		action: [ 
			(element := DCVisualEllipse new) radiusX: 50 radiusY: 20.
			self onAction value: element ].
	polygonButton
		action: [ 
			(element := DCVisualPolygon new) addPoint: 10@0; addPoint: 20@10; addPoint: 10@20; addPoint: 0@10.
			self onAction value: element ].
	rectangleButton
		action: [ 
			(element := DCVisualRectangle new)
				borderRadius: 10;
				width: 50;
				height: 50.
			self onAction value: element ]