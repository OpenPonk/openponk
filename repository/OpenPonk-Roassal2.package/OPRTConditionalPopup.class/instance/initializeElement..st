initialization
initializeElement: element
	element
		when: TRMouseClick
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ].
		
	element
		when: TRMouseEnter
		do: [ :event | 
			self isEnabled ifTrue: [
				self createAndShowPopupFor: element event: event ] ].
	element
		when: TRMouseLeave
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ].
	element
		when: TRMouseDragging
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ]