hooks
initializeElement: element
	originElement := element.
	element when: TRMouseEnter do: [ :event | self activatePriority: 10 color: Color gray ].
	element when: TRMouseLeave do: [ :event | self deactivatePriority: 10 ].
	element when: DCTRSelectedEvent do: [ :event | self activatePriority: 20 color: Color blue ].
	element when: DCTRUnselectedEvent do: [ :event | self deactivatePriority: 20 ]