private
initializeCallbacks
	stereotype
		whenChangedDo: [ :newValue | 
			topGroup first trachelShape text: (self stereotypeFor: newValue).
			self update ].
	name
		whenChangedDo: [ :newValue | 
			topGroup last trachelShape text: newValue.
			self update ].
	attributes whenChangedDo: [ :newValue | self update ].
	methods whenChangedDo: [ :newValue | self update ].
	background
		addCallback:
			(TRRemoveCallback
				block: [ 
					group do: #remove.
					separatorGroup do: #remove ])