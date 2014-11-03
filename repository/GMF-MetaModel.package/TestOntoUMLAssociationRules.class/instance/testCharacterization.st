running
testCharacterization
	| association |
	association := Characterization
						name: 'Characterization'
						start: (Kind name: 'Mode' metaModel: metaModel)
						end: (Kind name: 'TestKind' metaModel: metaModel).
		
	self deny: association isElementValid.
	
	association := Characterization
						name: 'Characterization'
						start: (Quality name: 'Quality' metaModel: metaModel)
						startMultiplicity: 1
						end: (Kind name: 'TestKind2' metaModel: metaModel)
						endMultiplicity: 1.
		
	self assert: association isElementValid