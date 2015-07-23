hooks
showResizeHandleOn: element
	super showResizeHandleOn: element.
	(element attributeAt: #resizeHandle) trachelShape pushFront