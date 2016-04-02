*DynaCASE-Core-accessing
lastLink
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail