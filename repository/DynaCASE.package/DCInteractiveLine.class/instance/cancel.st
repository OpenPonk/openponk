actions
cancel
	self running
		ifTrue: [ 
			line remove.
			diagramController view removeElement: mouseBox.
			diagramController cancelInteractiveLine.
			diagramController updateView.
			target := nil.
			running := false ]