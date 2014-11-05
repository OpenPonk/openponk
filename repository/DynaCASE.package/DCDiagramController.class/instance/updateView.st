userinterface
updateView
	self controllers do: [ :each | each figure update ].	"does not work with DCUmliteClassController view"
	self view edges
		do: [ :each | 
			each pushBack.
			each update ].
	self view signalUpdate