specs
defaultSpec
	^ SpecLayout composed
		newColumn: [ :c | 
					c
						add: #nameLabel;
						newRow: [ :row | 
									row
										add: #rectangleButton;
										add: #polygonButton;
										add: #circleButton;
										add: #ellipseButton ] ];
		yourself