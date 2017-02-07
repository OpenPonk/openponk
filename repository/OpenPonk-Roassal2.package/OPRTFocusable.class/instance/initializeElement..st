hooks
initializeElement: element
	element
		when: OPTRFocused
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ].
	element
		when: OPTRUnfocused
		do: [ :e | 
			self doUnhighlight: element.
			e signalUpdate ]