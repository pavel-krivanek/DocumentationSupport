Extension { #name : #DocChapter }

{ #category : #'*DocumentationSupport-UI' }
DocChapter >> asPresenter [ 

	^ (DocChapterPresenter on: self)
]

{ #category : #'*DocumentationSupport-UI' }
DocChapter >> icon [ 

	^ self iconNamed: #page 
]

{ #category : #'*DocumentationSupport-UI' }
DocChapter >> presenterClass [

	^ DocChapterPresenter 
]
