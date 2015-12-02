initialization
lazyInitializeElement: anEdge
	edge := anEdge.
	edge shape router handler: self.
	visible := false.
	edge when: TRMouseLeftClick do: [ self showHandles ].
	edge trachelShape addCallback: (TRRemoveCallback block: [ self removeHandles ]).
	self connectWithView: edge view