as yet unclassified
refreshFigure
	figure labels first shape text: (self convertName: self model name).
	figure labels first update.

	figure labels second shape text: self model sourceName.
	figure labels second update.

	figure labels third shape text: self model targetName.
	figure labels third update.

	figure signalUpdate