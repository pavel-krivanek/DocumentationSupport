Extension { #name : #PRDocumentItem }

{ #category : #'*DocumentationSupport' }
PRDocumentItem >> acceptDecorated: aVisitor [

	^ self accept: aVisitor
]
