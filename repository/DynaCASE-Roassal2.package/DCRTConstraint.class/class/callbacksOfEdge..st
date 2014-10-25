private 
callbacksOfEdge: anEdge
	| callbacks |
	callbacks := Bag with: TRTranslationCallback new with: TRExtentCallback new.
	callbacks
		do: [ :each | 
			anEdge from addCallback: each.
			anEdge to addCallback: each ].
	^ callbacks