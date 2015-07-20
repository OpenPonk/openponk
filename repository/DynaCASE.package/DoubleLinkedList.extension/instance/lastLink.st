*DynaCASE-accessing
lastLink
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail