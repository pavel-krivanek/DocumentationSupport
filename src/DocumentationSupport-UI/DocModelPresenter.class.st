"
A presenter with aspect change announcements support
"
Class {
	#name : #DocModelPresenter,
	#superclass : #SpPresenter,
	#category : #'DocumentationSupport-UI-Presenters'
}

{ #category : #specs }
DocModelPresenter class >> defaultSpec [

	^ self subclassResponsibility
]

{ #category : #events }
DocModelPresenter >> aspect: anAspect changedFrom: anOrigin [

	self subclassResponsibility 
]

{ #category : #events }
DocModelPresenter >> whenAspectChanged: ann [ 

	self aspect: ann aspect changedFrom: ann origin

]
