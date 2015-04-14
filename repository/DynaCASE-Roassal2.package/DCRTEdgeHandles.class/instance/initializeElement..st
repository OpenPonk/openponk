hooks
initializeElement: anEdge
	anEdge view ifNil: [ self error: 'Edge must be added to the view.' ].
	edge := anEdge.
	bendPoints add: edge from.
	bendPoints add: edge to.
	edge shape block: [ :from :to | self path ].
	self addMouseInteractivity.
	self updateHandles.
	edge update
	"	edge view signalUpdate"