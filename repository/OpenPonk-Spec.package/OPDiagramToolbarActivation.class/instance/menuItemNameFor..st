accessing
menuItemNameFor: aCommand
	^ menuItemName ifNil: [ aCommand defaultToolbarItemName ]