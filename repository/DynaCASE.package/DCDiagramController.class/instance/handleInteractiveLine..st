as yet unclassified
handleInteractiveLine: anInteractiveLine
	self view when: TRMouseMove do: [ :event | anInteractiveLine attachToMouseOn: event position ].
	self controllers do: [ :ctrl | ctrl handleInteractiveLine: anInteractiveLine ]