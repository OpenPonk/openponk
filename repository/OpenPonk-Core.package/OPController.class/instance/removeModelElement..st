deprecated
removeModelElement: aModelElement
	"Remove self as target of aModelElement"
	self deprecated: 'use #removeModel on the proper controller instead.'.

	self subclassResponsibility