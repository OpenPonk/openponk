accessing
default
	"self default inspect"
	^ Default ifNil: [ Default := self new ]