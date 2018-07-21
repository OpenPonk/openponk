example
example
	| proj model |
	proj := OPProject new.
	model := OPTestContainerModel new.
	model entities add: OPTestEntityModel new.
	proj addModel: model.
	proj open