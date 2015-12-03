private
setupView: aView
	aView canvas eventOverseer ifNil: [ aView canvas eventOverseer: TRAnnouncingOverseer new ].
	aView attributeAt: self className put: true