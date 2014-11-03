running
testModeAndQuality
	| mode |
	mode := Mode name: 'Mode' metaModel: metaModel.
	
	self deny: mode isElementValid.
	
	Characterization
		name: 'Characterization'
		start: mode
		end: (Kind name: 'TestKind' metaModel: metaModel).
		
	self assert: mode isElementValid