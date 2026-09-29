"
Abstract base class for diagram-only shapes (such as boundaries and notes) that incorporate a text label. 
Handles common concerns like text wrapping, padding, and positioning the inner label.
"
Class {
	#name : 'OPDiagramOnlyShapeWithText',
	#superclass : 'OPDiagramOnlyShape',
	#traits : 'OPTResizableFigureWithText',
	#classTraits : 'OPTResizableFigureWithText classTrait',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}
