accessing
writer
	^ writer ifNil: [ writer := self defaultWriter ]