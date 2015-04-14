as yet unclassified
addMidpointFor: aPoint
	| handle |
	self logCr: aPoint.
	handle := self handleShape elementOn: aPoint.
	handle addConnectedEdge: edge.
	handle translateBy: aPoint.
	handle @ RTDraggable.
	handles add: handle.
	edge view add: handle.
	self resetPath