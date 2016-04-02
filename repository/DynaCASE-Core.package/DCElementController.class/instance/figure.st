accessing
figure
	^ figure ifNil: [ figure := self createFigure renderIn: self diagramController view ]