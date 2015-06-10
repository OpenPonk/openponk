initialization
initialize
	super initialize.
	figures := RTGroup new.
	removedFigures := OrderedCollection new.
	background := self defaultBackground.
	background addCallback: (TRTranslationCallback block: [ :aShape :step | self translateFiguresBy: step ])