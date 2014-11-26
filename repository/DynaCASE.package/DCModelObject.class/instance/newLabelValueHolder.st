initialization
newLabelValueHolder
	^ (NewValueHolder value: '') whenChangedDo: [ self changed ]