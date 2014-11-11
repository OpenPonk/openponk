running
stick
	"moves shape according to edge positions and settings whenever edge is moved;
	when shape is dragged, change settings via fix method"

	self
		move;
		setCallbacksOfEdge;
		subscribeShapeDrag