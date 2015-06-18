running
testRemoveElement
	| memberOf |
	
	Collective name: 'Friends' metaModel: metaModel.
	
	memberOf := MemberOf 	name: 				'person' 
								start:				(Kind name: 'Person' metaModel: metaModel)
								startMultiplicity: 	'1'
								end: 				(metaModel at: 'Friends')
								endMultiplicity: 		'1..*'.
	
	memberOf := MemberOf 	name: 				'animal' 
								start:				(Kind name: 'Animal' metaModel: metaModel)
								startMultiplicity: 	'1'
								end: 				(metaModel at: 'Friends')
								endMultiplicity: 		'1..*'.
										
	
	metaModel removeElement: (metaModel at: 'Friends').
	
	self assert: metaModel modelElements size = 2.
	self assert: (metaModel at: 'Animal') associations size = 0.
	self assert: (metaModel at: 'Person') associations size = 0
	
	
	
	