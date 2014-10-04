adding
addTextInput: aLabel value: aString onChange: aOneArgBlock
	| item |
	item := self newTextInput.
	item text: aString.
	item whenTextChanged: [ :newValue | aOneArgBlock value: newValue ].
	components add: item