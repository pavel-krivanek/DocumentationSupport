"
I am an abstract class of documentation reposotories. The main purpose of the repository is to provide the libraries contained in the repository.
"
Class {
	#name : #DocLibraryRepository,
	#superclass : #Object,
	#category : #'DocumentationSupport-Model'
}

{ #category : #accessing }
DocLibraryRepository >> libraries [  

	^ self subclassResponsibility 
]
