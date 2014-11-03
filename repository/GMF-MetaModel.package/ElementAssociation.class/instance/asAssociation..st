private
asAssociation: xAssociation 
	xAssociation start: start.
	xAssociation end: end.
	xAssociation endMultiplicity: endQuantity.
	xAssociation startMultiplicity: startQuantity.
	start removeAssociation: name.
	end removeAssociation: name.
	start associations add: xAssociation.
	end associations add: xAssociation. 
	
	^ xAssociation