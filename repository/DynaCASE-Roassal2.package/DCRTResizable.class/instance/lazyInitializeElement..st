initialization
lazyInitializeElement: anElement
	element := anElement.
	element when: TRMouseLeftClick do: [ :evt | self showHandles ].
	element when: TRMouseDragStart do: [ :evt | self disable ].
	element when: TRMouseDragEnd do: [ :evt | self enable ].
	element addCallback: (TRRemoveCallback block: [ :evt | self removeHandles ]).

	self connectWithView: (view ifNil: [ element view ]).

	self enable