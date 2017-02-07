protocol
select
	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal | oldVal ifNotNil: [ oldVal remove ] ].
	connectionController := factory value.
	self selectSource