hooks
setupView: aView
	aView canvas eventOverseer ifNil: [ aView canvas eventOverseer: DCTRAnnouncingOverseer new ].

	aView canvas eventOverseer
		when: TRMouseLeftClick
		do: [ :evt | aView announcer announce: (DCTRResizeCanceled shape: evt shape) ].
	aView attributeAt: self className put: true