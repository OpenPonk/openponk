instance creation
newFigureWithoutSpacing
	| fig |
	fig := DCOmlClassFigure new.
	fig layout gapSize: 0.
	fig padding: 0 @ 0.
	fig attributes layout gapSize: 0.
	fig attributes padding: 0 @ 0.
	fig operations layout gapSize: 0.
	fig operations padding: 0 @ 0.
	^ fig