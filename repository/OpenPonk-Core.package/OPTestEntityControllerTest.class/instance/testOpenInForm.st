tests - ui interaction
testOpenInForm
	| form |
	form := OPDynamicForm new.
	diagramController stub formPresenter willReturn: form.
	self assert: form widgets isEmpty.
	diagramController openInForm: controller.
	self assert: form widgets isNotEmpty