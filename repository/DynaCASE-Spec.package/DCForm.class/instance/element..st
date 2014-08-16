accessing
element: aModelElement
	element := aModelElement.
	element ifNil: [ self nameField text: '' ] ifNotNil: [ self nameField text: element name ]