events
registerInteractions
	"subclass me to register additional interactions"

	background @ RTDraggable.
	background addCallback: (TRTranslationCallback block: [ :aShape :step | self translateFiguresBy: step ])