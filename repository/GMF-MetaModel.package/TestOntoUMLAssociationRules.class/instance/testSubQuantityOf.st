running
testSubQuantityOf
	| subQuantityOf |
	subQuantityOf := SubQuantityOf 
				name: 'SubQuantityOf'
				start: (Quantity name: 'MineralWater' metaModel: metaModel)
				startMultiplicity: '1'
				end: (Quantity name: 'Minerals' metaModel: metaModel)
				endMultiplicity: '1'.
				
	self deny: subQuantityOf isElementValid.
	
	subQuantityOf essential: true.
	
	self assert: subQuantityOf isElementValid