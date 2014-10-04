hooks
populateForm: aForm
	aForm nameFieldText: self model name.
	aForm whenNameFieldChanged: [ :newValue | self model name: newValue ].
	aForm textFieldText: self model sourceName , String cr , self model targetName.
	aForm
		whenTextFieldChanged: [ :aText | 
			| lines |
			lines := aText asString trim lines.
			lines size > 0
				ifTrue: [ self model sourceName: lines first ]
				ifFalse: [ self model sourceName: '' ].
			lines size > 1
				ifTrue: [ self model targetName: lines second ]
				ifFalse: [ self model targetName: '' ] ]