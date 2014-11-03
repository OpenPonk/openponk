removing
removeAttribute: xName
	attributes := attributes reject: [ :each | each name = xName ]