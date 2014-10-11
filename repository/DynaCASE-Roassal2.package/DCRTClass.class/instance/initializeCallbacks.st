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
	methods whenChangedDo: [ :newValue | self update ].
	background trachelShape
		addCallback:
			(TRRemoveCallback
				block: [ 
					topGroup do: #remove.
					attributesGroup do: #remove.
					methodsGroup do: #remove.
					separatorGroup do: [ :each | each do: #remove ] ])