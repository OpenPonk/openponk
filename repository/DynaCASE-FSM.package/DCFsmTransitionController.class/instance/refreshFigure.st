hooks
refreshFigure
	(figure labels at: #name) shape text: self model name.
	(figure labels at: #name) update.
	figure signalUpdate