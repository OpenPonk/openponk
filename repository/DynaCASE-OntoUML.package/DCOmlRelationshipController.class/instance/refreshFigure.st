hooks
refreshFigure
	figure labels first shape text: (self convertName: self model name).
	figure labels first update.

	figure labels second shape text: self model startMultiplicity.
	figure labels second update.

	figure labels third shape text: self model endMultiplicity.
	figure labels third update.

	figure signalUpdate