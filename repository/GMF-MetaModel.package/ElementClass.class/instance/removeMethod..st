removing
removeMethod: xName
	methods := methods reject: [ :each | each name = xName ]