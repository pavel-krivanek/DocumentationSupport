Extension { #name : #DocLibrary }

{ #category : #'*DocumentationSupport-UI' }
DocLibrary >> asPresenter [ 

	^ (DocLibraryPresenter on: self)
]

{ #category : #'*DocumentationSupport-UI' }
DocLibrary class >> browserNavigates: objects [ 

	| references selected  |
	
	true ifTrue: [ ^ self ].
	
	references := self referencesCache.
	
	selected := Set new.
	
	objects do: [ :each | 
		references do: [ :refAssoc |
			refAssoc key = each ifTrue: [ 
				refAssoc value do: [ :chapter |
					selected add: chapter ] ]	
		] ].
	
	selected ifNotEmpty: [ 
		(selected collect: #title) traceCr ]
]
