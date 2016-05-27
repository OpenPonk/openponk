singleton
default
	^ Default ifNil: [ Default := self withAll ]