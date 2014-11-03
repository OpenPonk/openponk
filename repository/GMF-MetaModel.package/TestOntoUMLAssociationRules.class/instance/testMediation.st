running
testMediation
	| mediation |
	mediation := Mediation 
					name: 				'Mediation' 
					start: 				( Relator name: 'Relator' metaModel: metaModel )  
					startMultiplicity: 	'1..n' 
					end: 				( Role name: 'Role1' metaModel: metaModel )  
					endMultiplicity: 		'1'.
	
	self assert: mediation isElementValid.
	
	mediation startMultiplicity: '0..n'.
	mediation endMultiplicity: '0..n'.
	
	self deny: mediation isElementValid