private
cull: aSomething with: anObject
	^ (aSomething isKindOf: Symbol) | (aSomething isKindOf: BlockClosure)
		ifTrue: [ aSomething cull: anObject ]
		ifFalse: [ aSomething ]