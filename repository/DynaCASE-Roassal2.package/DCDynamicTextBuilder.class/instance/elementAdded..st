hooks
elementAdded: anElement
	| cb |
	parent ifNil: [ self update ] ifNotNil: [ parent update ].
	cb := TRTranslationCallback block: [ :shape :step | anElement translateBy: step ].
	callbacks add: cb.
	background trachelShape addCallback: cb.
	view add: anElement