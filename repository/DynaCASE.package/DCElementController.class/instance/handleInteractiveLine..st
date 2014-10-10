interaction
handleInteractiveLine: anInteractiveLine
	self view when: TRMouseMove do: [ :event | anInteractiveLine attachTo: self view ]