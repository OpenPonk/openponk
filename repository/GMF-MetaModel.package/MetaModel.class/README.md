MetaModel class is the main class of OntoUML metamodel. Through this class we can add, remove elements and get elements from metamodel.

Usage:
metamodel := MetaModel new.
Kind name: 'Test' metaModel: metamodel.

Now get specific element from metamodel:
metamodel at: 'Test'.

Or get all elements:
metamodel modelElements.

More examples we can find in package GMF-MetaModel-Tests.