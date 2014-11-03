running
testRemoveElement
	| objectToRemove |
	
	objectToRemove := Kind name: 'ElementToRemove' metaModel: metaModel.
	
	metaModel removeElement: objectToRemove.
	
	self assert: metaModel modelElements size = 0
	
	
	
	