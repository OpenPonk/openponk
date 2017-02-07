accessing
controllerClass
	| name |
	name := self class name asString.
	name := name copyFrom: 1 to: name size - 4.
	^ name asClass