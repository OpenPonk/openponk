*DynaCASE-Core-accessing
tail
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail