accessing
menuItemNameFor: aCommand
	^ menuItemName ifNil: [ aCommand defaultMenuItemName ]