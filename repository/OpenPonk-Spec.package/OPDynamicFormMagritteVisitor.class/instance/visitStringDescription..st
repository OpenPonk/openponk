visiting
visitStringDescription: aStringDescription
	aStringDescription isReadonly
		ifTrue: [ ^ self visitLabelDescription: aStringDescription ].
	(form addTextInput: aStringDescription label)
		text: (aStringDescription accessor read: controller);
		whenTextIsAccepted: [ :newValue | 
			[ aStringDescription validate: newValue.
			aStringDescription accessor write: newValue to: controller ]
				on: MAValidationError
				do: [ :e | self inform: e messageText ] ];
		in: [ :input | aStringDescription accessor opWhenUpdated: [ :newValue | input text: newValue ] ]