instance creation
newBox: aSize
	^ RTBox new
		width: aSize x;
		height: aSize y;
		element