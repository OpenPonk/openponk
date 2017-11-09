tests
testBuildEditorForm
	self skip.
	"| form |
	form := OPDynamicForm new.
	controller model: model.
	self shouldnt: [ controller buildEditorForm: form ] raise: Error"