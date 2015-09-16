initialization
lazyInitializeElement: anEdge
	edge := anEdge.
	visible := false.
	edge when: TRMouseLeftClick do: [ self showHandles ].
	edge trachelShape addCallback: (TRRemoveCallback block: [ self removeHandles ]).
	self connectWithView: edge view