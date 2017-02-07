running
stick
	"Moves shape according to edge positions and settings whenever edge is moved.
	When shape is dragged, change settings via fix method"

	self
		move;
		setCallbacksOfEdge;
		subscribeShapeDrag