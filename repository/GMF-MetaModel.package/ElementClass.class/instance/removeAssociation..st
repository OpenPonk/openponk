removing
removeAssociation: aName
	| association |
	
	[ association := self searchAssociation: aName.
	  associations := associations reject: [ :each | each name = aName ].
		
	  association start removeAssociation: aName.
	  association end removeAssociation: aName ]
		on: Error
		do: [ ^ false ]
