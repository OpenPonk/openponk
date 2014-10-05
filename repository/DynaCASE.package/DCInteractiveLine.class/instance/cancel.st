actions
cancel
	self running
		ifTrue: [ 
			line remove.
			diagramController view removeElement: mouseBox.
			diagramController view announcer unsubscribe: self.
			diagramController controllers do: [ :ctrl | ctrl view announcer unsubscribe: self ].
			diagramController updateView.
			target := nil.
			running := false ]