as yet unclassified
removeFromView
	self first view ifNotNil: [ self do: [ :each | each remove ] ]