running
testCollective
	| collective |
	collective := Collective name: 'Friends' metaModel: metaModel.
	
	MemberOf 	name: 				'person' 
				start:				(Kind name: 'Person' metaModel: metaModel)
				startMultiplicity: 	'0'
				end: 				collective
				endMultiplicity: 		'1..*'.
						
	self assert: collective isElementValid.
	
	MemberOf 	name: 				'animal' 
				start:				(Kind name: 'Animal' metaModel: metaModel)
				startMultiplicity: 	'0'
				end: 				collective
				endMultiplicity: 		'1..*'.
	collective extensional: true.
	
	self deny: collective isElementValid
	