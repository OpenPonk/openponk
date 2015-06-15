figures
refreshFigure
	self figure from = self figure to
		ifTrue: [ 
			(self figure attributeAt: #DCArcLabel)
				model: self model name;
				update ]
		ifFalse: [ self figureLabel: #name text: self model name ].
	super refreshFigure