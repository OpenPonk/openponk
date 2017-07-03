visiting
visitStringDescription: aStringDescription
	aStringDescription isReadonly
		ifTrue: [ ^ self visitLabelDescription: aStringDescription ].
	(form addTextInput: aStringDescription label)
		text: (aStringDescription accessor read: controller);
		whenTextIsAccepted: [ :newValue | aStringDescription accessor write: newValue to: controller ]