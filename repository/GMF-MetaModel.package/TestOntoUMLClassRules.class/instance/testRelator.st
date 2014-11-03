running
testRelator
	| relator |
	relator := Relator name: 'Relator' metaModel: metaModel.
	Mediation
		name: 'FirstMediation'
		start: relator
		end: (Role name: 'FirstRole' metaModel: metaModel).
		
	self deny: relator isElementValid.
	
	Mediation
		name: 'SecondMediation'
		start: relator
		end: (Role name: 'SecondRole' metaModel: metaModel).
		
	self assert: relator isElementValid