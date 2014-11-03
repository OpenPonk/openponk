hooks
initializeElement: element
	element
		when: DCTRFocused
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ].
	element
		when: DCTRUnfocused
		do: [ :e | 
			self doUnhighlight: element.
			e signalUpdate ]