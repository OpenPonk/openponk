hooks
figure
	^ figure ifNil: [ figure := self createFigure renderIn: self parent view ]