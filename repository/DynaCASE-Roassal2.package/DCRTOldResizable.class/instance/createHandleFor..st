hooks
createHandleFor: element
	| handle |
	handle := self defaultHandleShape element.
	handle addCallback: (self callbackFor: handle element: element).
	handle @ RTDraggable.
	handle when: TRMouseLeave do: [ :evt | self removeResizeHandleOn: element ].
	element addCallback: (TRRemoveCallback block: [ self removeResizeHandleOn: element ]).

	^ handle