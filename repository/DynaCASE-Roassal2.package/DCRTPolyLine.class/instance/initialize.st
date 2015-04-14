initialization
initialize
	super initialize.
	points := DoubleLinkedList new.
	segments := OrderedCollection new.
	handles := OrderedCollection new