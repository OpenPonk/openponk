adding
addLabel: aName value: aString
	| control |
	control := self newLabel.
	control text: aString.
	components add: (Array with: aName with: control)