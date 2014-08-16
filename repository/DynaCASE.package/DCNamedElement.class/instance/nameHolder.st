accessing
nameHolder
	^ name ifNil: [ name := NewValueHolder new ]