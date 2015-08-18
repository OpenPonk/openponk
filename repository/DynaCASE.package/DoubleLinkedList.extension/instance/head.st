*DynaCASE-accessing
head
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ head