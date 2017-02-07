*OpenPonk-Core-accessing
firstLink
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ head