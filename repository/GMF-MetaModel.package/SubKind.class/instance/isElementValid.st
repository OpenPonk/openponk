validating
isElementValid
	self generalizations do: [:each | 
		( each parent  isKindOf: SubstanceSortal ) ifTrue: [ ^ super isElementValid ].
		( each parent isMemberOf: SubKind ) ifTrue: [ ^ each parent isElementValid ] ].

     ^ false.