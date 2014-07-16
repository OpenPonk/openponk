accessing
cornerRadius
	^ cornerRadius ifNil: [ cornerRadius := self defaultCornerRadius ]