removing
removeElement: anElement
	| collection |
	collection := OrderedCollection new.
	collection add: anElement name.
	
	modelElements removePath: collection
