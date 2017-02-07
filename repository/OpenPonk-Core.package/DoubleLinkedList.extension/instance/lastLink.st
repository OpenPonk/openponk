*OpenPonk-Core-accessing
lastLink
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ tail