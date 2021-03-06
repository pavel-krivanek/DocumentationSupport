Extension { #name : #DocModelWithKey }

{ #category : #'*DocumentationSupport-UI' }
DocModelWithKey >> asPresenterIn: anApplication [

	^ (self presenterClass on: self)
]

{ #category : #'*DocumentationSupport-UI' }
DocModelWithKey >> openIn: anApplication [

	(self asPresenterIn: anApplication) openWithSpec
]

{ #category : #'*DocumentationSupport-UI' }
DocModelWithKey >> presenterClass [ 

	^ self subclassResponsibility 
]
