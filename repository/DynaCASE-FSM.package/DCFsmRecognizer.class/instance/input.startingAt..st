stepping
input: aString startingAt: aState
	self reset.
	
	aString reverseDo: [ :each | input push: each ].
	self goTo: aState outgoing anyOne target	"skip the initial state"