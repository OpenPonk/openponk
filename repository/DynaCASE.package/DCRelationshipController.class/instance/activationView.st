interaction
activationView
	^ activationView
		ifNil: [ 
			activationView := RTNoShape new element.
			self view
				when: TRMouseEnter
				do: [ :event | 
					self activateLevel: 10 color: Color gray.
					view signalUpdate ].
			self view
				when: TRMouseLeave
				do: [ :event | 
					self deactivateLevel: 10.
					view signalUpdate ] ]