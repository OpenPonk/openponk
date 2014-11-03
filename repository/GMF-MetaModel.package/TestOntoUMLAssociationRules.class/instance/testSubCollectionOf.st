running
testSubCollectionOf
	| subCollectionOf |
	Collective name: 'Company' metaModel: metaModel.
	
	subCollectionOf := SubCollectionOf 	name: 				'management' 
											start:				(Collective name: 'Management' metaModel: metaModel)
											startMultiplicity: 	'1'
											end: 				(metaModel at: 'Company')
											endMultiplicity: 		'1..*'.
	self assert: subCollectionOf isElementValid.
	
	subCollectionOf := SubCollectionOf 	name: 				'projectTeam' 
											start:				(Kind name: 'ProjectTeam' metaModel: metaModel)
											startMultiplicity: 	'1'
											end: 				(metaModel at: 'Company')
											endMultiplicity: 		'1..*'.
	self deny: subCollectionOf isElementValid.
	