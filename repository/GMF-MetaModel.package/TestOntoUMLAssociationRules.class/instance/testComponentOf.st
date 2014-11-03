running
testComponentOf
	| component |
	Kind name: 'Person' metaModel: metaModel.
	Kind name: 'Brain' metaModel: metaModel.
	
	component := ComponentOf 	name: 				'brain' 
									start:				(metaModel at: 'Brain')
									startMultiplicity: 	'1'
									end: 				(metaModel at: 'Person')
									endMultiplicity: 		'1'.
	self assert: component isElementValid.
	
	component := ComponentOf 	name: 				'heart' 
									start:				(Phase name: 'heart' metaModel: metaModel)
									startMultiplicity: 	'1'
									end: 				(metaModel at: 'Person')
									endMultiplicity: 		'1'.
	self deny: component isElementValid.
