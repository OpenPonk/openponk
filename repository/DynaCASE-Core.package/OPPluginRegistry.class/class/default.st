singleton
default
	^ Default ifNil: [ self withAll ]