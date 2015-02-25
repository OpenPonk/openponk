private
addToView: aRoassalView
	aRoassalView
		ifNotNil: [ 
			aRoassalView
				add: center;
				add: centerDragBox ]