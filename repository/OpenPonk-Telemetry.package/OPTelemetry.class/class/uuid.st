accessing
uuid
	^ uuid ifNil: [ uuid := self storeLoadUuid ]