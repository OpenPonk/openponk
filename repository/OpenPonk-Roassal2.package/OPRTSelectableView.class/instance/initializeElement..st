initialization
initializeElement: aView
	super initializeElement: aView.
	view canvas eventOverseer ifNil: [ view canvas eventOverseer: TRAnnouncingOverseer new ].
	view canvas eventOverseer
		when: TRMouseLeftClick
		do: [ :evt | 
			self removeSelection: self candidates.
			view attributeAt: self class put: #() ]