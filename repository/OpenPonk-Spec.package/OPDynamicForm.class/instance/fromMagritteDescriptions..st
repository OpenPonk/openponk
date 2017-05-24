public
fromMagritteDescriptions: aContainer
	| visitor |
	visitor := OPDynamicFormMagritteVisitor new.
	visitor form: self.
	visitor controller: controller.
	visitor visit: aContainer