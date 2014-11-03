running
testCategory
	| category |
	category := Category
				name: 'Category'
				abstract: true
				metaModel: metaModel.
				
	self deny: category isElementValid.
	
	category
		addSubObject: (Kind name: 'SubObject' metaModel: metaModel).
		
	self assert: category isElementValid