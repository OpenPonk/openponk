updating
remove
	self do: [ :each | each view ifNotNil: [ each remove ] ]