menu commands
editElementCommand: aModelElement
	UIManager default inform: 'Editing from tree is disabled'	"disabled due to not having controller at our disposal atm"	"	self openInForm: (self findControllerByModel: aModelElement)"