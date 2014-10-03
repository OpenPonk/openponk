as yet unclassified
cancel
	
	self running ifTrue: [
	diagramController view removeEdge: line.
	diagramController view removeElement: mouseBox.
	diagramController view announcer unsubscribe: self.
	diagramController controllers do: [ :ctrl | ctrl view announcer unsubscribe: self].
	diagramController updateView.
	running := false.
	]