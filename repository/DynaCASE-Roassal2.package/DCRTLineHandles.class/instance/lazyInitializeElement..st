initialization
lazyInitializeElement: anEdge
	edge := anEdge.
	visible := false.
	edge
		when: TRMouseLeftClick
		do:
			[ 
			visible
				ifFalse: [ edge shape showHandlesFor: edge ].
			visible := visible not ].
	edge trachelShape
		addCallback: (TRRemoveCallback block: [ edge shape removeHandlesFor: edge ]).
	self connectWithView: edge view