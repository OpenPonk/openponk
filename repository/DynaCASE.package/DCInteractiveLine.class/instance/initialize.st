initialization
initialize
	
	super initialize.
	running := false.
	mouseBox := RTBox element height: 0; width: 0; yourself. mouseBox color: Color transparent.
	self diagramCtrl: nil; from: nil.	
	target := nil.