as yet unclassified
initializeElement: element
	element
		when: TRMouseLeftClick
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ]