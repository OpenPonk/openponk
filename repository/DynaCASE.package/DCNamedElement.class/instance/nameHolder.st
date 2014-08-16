accessing
nameHolder
	^ name ifNil: [ name := NewValueHolder value: '' ]