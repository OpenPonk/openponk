hooks
setupView: aView
	aView canvas eventOverseer ifNil: [ aView canvas eventOverseer: TRAnnouncingOverseer new ].

	"aView canvas eventOverseer
		when: TRMouseLeftClick
		do: [ :evt | aView announcer announce: (TRResizeCanceled shape: evt shape) ]."
	aView attributeAt: self className put: true