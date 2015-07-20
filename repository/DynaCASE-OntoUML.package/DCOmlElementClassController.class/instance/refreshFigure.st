hooks
refreshFigure
	figure model name: self model name.
	figure model attributes: (self model attributes collect: #asString).
	figure model methods: (self model methods collect: #asString).
	super refreshFigure