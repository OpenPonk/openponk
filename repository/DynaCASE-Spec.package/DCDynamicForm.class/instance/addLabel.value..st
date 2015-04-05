adding
addLabel: aName value: aString
	| control |
	control := self newLabel.
	control
		label: aString;
		emphasis: 1.
	components add: (Array with: aName with: control)