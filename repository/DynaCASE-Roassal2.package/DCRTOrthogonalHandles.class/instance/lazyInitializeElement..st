hooks
lazyInitializeElement: anEdge
	edge := anEdge.
	edge when: TRMouseLeftClick do: [ :evt | self showHandles ].
	edge from addCallback: (TRRemoveCallback block: [ :evt | self removeHandles ]).
	self connectWithView: anEdge view
	"| visible |
	visible := false.
	anEdge
		when: TRMouseLeftClick
		do: [ 
			visible
				ifTrue: [ anEdge shape removeHandlesFor: anEdge ]
				ifFalse: [ anEdge shape showHandlesFor: anEdge ].
			visible := visible not ].
	anEdge trachelShape addCallback: (TRRemoveCallback block: [ anEdge shape removeHandlesFor: anEdge ])"