"
An model with support of `DocAspectChanged` announcements
"
Class {
	#name : #DocModel,
	#superclass : #Model,
	#category : #'DocumentationSupport-Model'
}

{ #category : #events }
DocModel >> aspectChanged: aSymbol [ 

	self announcer announce: (DocAspectChanged new 
		aspect: aSymbol;
		origin: self;
		yourself)
]

{ #category : #events }
DocModel >> whenAspectChangedNotify: anObject [ 

	self announcer weak when: DocAspectChanged send: #whenAspectChanged: to: anObject.

]
