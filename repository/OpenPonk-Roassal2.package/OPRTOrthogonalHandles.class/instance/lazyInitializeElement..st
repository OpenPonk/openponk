initialization
lazyInitializeElement: anEdge
	edge := anEdge.
	edge shape
		router:
			(OPRTOrthogonalRouter new
				points: (edge shape pathFor: edge);
				handler: self;
				yourself).
	edge when: TRMouseLeftClick do: [ self addHandles ].
	edge trachelShape addCallback: (TRRemoveCallback block: [ self removeHandles ]).
	self connectWithView: edge view.
	self addHandles.
	self removeHandles