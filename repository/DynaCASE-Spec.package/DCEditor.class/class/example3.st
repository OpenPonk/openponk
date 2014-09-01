instance creation
example3
	| diagram firstClass |
	diagram := DCUmliteDiagram new.
	firstClass := DCUmliteClass new name: 'FirstClass'.
	firstClass
		attributes:
			'-attr1
-attr2' lines asOrderedCollection.
	diagram add: firstClass.
	^ self openOn: diagram