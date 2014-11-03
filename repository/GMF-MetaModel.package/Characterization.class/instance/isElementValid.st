validating
isElementValid
	(start isMemberOf: Mode) | (start isMemberOf: Quality) 
		ifTrue: [ (self endMultiplicity = '1') & ((self startMultiplicity at:1) > $0)
					ifTrue: [ ^true ] ].
	
	(end isMemberOf: Mode) | (end isMemberOf: Quality) 
		ifTrue: [ (self endMultiplicity multiplicity = '1') & ((self startMultiplicity multiplicity at:1) > $0)
					ifTrue: [ ^true ] ].			
	^ false