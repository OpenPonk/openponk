adding
addLabel: aName value: aString
	| control |
	control := self newLabel.
	control label: aString.
	components add: (Array with: aName with: control)