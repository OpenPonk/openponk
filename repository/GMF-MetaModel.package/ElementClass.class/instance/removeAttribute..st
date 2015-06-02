removing
removeAttribute: aNameString
	attributes := attributes reject: [ :each | each name = aNameString ]