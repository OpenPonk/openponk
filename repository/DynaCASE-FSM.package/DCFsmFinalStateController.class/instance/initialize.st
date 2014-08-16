initialization
initialize
	viewBlock := [ 
	| shape |
	view := RTElement new.
	shape := DCRoassalSmFinalState new
		size: 50;
		color: Color white;
		borderColor: Color black.
	view + shape ]