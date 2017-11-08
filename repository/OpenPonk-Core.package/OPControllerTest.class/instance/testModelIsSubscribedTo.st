tests
testModelIsSubscribedTo
	controller := OPController new.
	model := Model new.
	controller model: model.
	self assert: model announcer subscriptions subscriptions anyOne subscriber equals: controller