running
testMemberOf
	| memberOf |
	Collective name: 'Friends' metaModel: metaModel.
	
	memberOf := MemberOf 	name: 				'person' 
								start:				(Kind name: 'Person' metaModel: metaModel)
								startMultiplicity: 	'1'
								end: 				(metaModel at: 'Friends')
								endMultiplicity: 		'1..*'.
	self assert: memberOf isElementValid.
	
	memberOf := MemberOf 	name: 				'alien' 
								start:				(Kind name: 'Alien' metaModel: metaModel)
								startMultiplicity: 	'1'
								end: 				(Kind name: 'TestElement' metaModel: metaModel)
								endMultiplicity: 		'1..*'.
	self deny: memberOf isElementValid.
	
	memberOf := MemberOf 	name: 				'animal' 
								start:				(Kind name: 'Animal' metaModel: metaModel)
								startMultiplicity: 	'1'
								end: 				(metaModel at: 'Friends')
								endMultiplicity: 		'1..*'.
	(metaModel at: 'Friends') extensional: true.
	self deny: memberOf isElementValid.