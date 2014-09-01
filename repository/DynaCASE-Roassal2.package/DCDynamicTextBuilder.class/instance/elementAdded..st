hooks
elementAdded: anElement
	| cb |
	self update.
	cb := TRTranslationCallback block: [ :shape :step | anElement translateBy: step ].
	callbacks add: cb.
	background trachelShape addCallback: cb.
	view add: anElement