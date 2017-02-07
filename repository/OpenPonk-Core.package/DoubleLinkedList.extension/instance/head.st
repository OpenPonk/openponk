*OpenPonk-Core-accessing
head
	self isEmpty
		ifTrue: [ CollectionIsEmpty signalWith: self ].
	^ head