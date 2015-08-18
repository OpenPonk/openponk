hooks
initializeElement: anElement
	element := anElement.
	visible := false.
	element
		when: TRMouseLeftClick
		do: [ 
			visible
				ifTrue: [ element shape removeHandlesFor: element ]
				ifFalse: [ element shape showHandlesFor: element ].
			visible := visible not ].
	element trachelShape addCallback: (TRRemoveCallback block: [ element shape removeHandlesFor: element ]).

	self connectWithView: element view