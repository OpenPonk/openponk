accessing
figure
	^ figure ifNil: [ figure := self createFigure ]