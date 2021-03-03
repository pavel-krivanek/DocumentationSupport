Extension { #name : #DocLibrary }

{ #category : #'*DocumentationSupport-UI' }
DocLibrary >> asPresenter [ 

	^ (DocLibraryPresenter on: self)
]
