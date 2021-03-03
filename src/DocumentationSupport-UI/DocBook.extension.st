Extension { #name : #DocBook }

{ #category : #'*DocumentationSupport-UI' }
DocBook >> asPresenter [ 

	^ (DocBookPresenter on: self)
]

{ #category : #'*DocumentationSupport-UI' }
DocBook >> asPresenterIn: anApplication [

	^ (DocBookPresenter on: self)
]

{ #category : #'*DocumentationSupport-UI' }
DocBook >> icon [ 

	^ self iconNamed: #book 
]

{ #category : #'*DocumentationSupport-UI' }
DocBook >> presenterClass [

	^ DocBookPresenter 
]
