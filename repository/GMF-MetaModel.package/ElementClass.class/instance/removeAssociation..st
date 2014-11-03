removing
removeAssociation: xName
	associations := associations reject: [ :each | each name = xName ]