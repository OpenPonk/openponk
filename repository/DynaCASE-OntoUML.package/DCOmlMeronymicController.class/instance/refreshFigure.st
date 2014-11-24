hooks
refreshFigure
	figure view ifNil: [ ^ self ].
	figure remove.
	figure := nil.
	self parent figureAdded: self figure.

	(figure labels at: #meronymic) shape text: (self meronymicStringFor: self model).
	(figure labels at: #meronymic) update.

	(figure labels at: #sourceMultiplicity) shape text: self model startMultiplicity.
	(figure labels at: #sourceMultiplicity) update.

	(figure labels at: #targetMultiplicity) shape text: self model endMultiplicity.
	(figure labels at: #targetMultiplicity) update.

	figure signalUpdate