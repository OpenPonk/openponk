initialization
defaultViewBlock
	^ [ :fromVertex :toVertex :rtView | 
	| label labelled |
	view := RTLine edgeFrom: fromVertex to: toVertex.
	view model: self model name.
	view shape color: Color black.
	labelled := RTLabelled new.
	labelled view: rtView.
	labelled initializeElement: view.
	self model nameHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			view update.
			view view signalUpdate ].
	view ]