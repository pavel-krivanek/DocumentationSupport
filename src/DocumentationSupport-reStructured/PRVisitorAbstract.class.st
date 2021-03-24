"
I am a visitor for `PRObject` objects in order to convert them in reStructuredText.
"
Class {
	#name : #PRVisitorAbstract,
	#superclass : #PRVisitor,
	#category : #'DocumentationSupport-reStructured'
}

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitAnchor: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitAnnotatedParagraph: anObject [

	super visitAnnotatedParagraph: anObject
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitAnnotation: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitBeginEnvironmentAnnotation: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitBoldFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitCodeblock: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitCommentedLine: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitDataItem: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitDefinitionList: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitDocumentItem: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitEmptyParagraph: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitExternalLink: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitFigure: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitHeader: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitHorizontalRule: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitInternalLink: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitItalicFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitLineBreak: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitLink: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitList: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitMailLink: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitMathEnvironment: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitMonospaceFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitOrderedList: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitParameter: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitParameterKey: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitParameterValue: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitParameters: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitPreformatted: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitRaw: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitReference: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitSection: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitStrikethroughFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitSubscriptFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitSuperscriptFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitTermItem: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitText: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitUndefinedAnnotation: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitUnderlineFormat: anObject [

	self shouldBeImplemented
]

{ #category : #'visiting-document' }
PRVisitorAbstract >> visitUnorderedList: anObject [

	self shouldBeImplemented
]
