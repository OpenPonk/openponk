private
initializeCallbacks
	stereotype
		whenChangedDo: [ :newValue | 
			topGroup first shape text: (self stereotypeFor: newValue).
			topGroup first update.
			self update ].
	name
		whenChangedDo: [ :newValue | 
			topGroup last shape text: newValue.
			topGroup last update.
			self update ].
	attributes whenChangedDo: [ :newValue | self update ].
	methods whenChangedDo: [ :newValue | self update ]