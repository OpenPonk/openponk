protocol
select
	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal | oldVal ifNotNil: [ oldVal remove ] ].
	objectController := factory value.
	self diagramController whenHoverChanged: [ :ctrl | self targetEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]