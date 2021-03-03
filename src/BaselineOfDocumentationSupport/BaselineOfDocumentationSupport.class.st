Class {
	#name : #BaselineOfDocumentationSupport,
	#superclass : #BaselineOf,
	#category : #BaselineOfDocumentationSupport
}

{ #category : #'window management' }
BaselineOfDocumentationSupport class >> documentationRepository [

	<documentationRepository>

	| ref repository location |
	repository := (IceRepository registry
		detect: [ :e | e name = 'DocumentationSupport' ] ifNone: [ nil ]). 
	location := repository 
		ifNotNil: [ repository location ].
		
	ref := location / 'doc-libs'.
	
	ref exists ifFalse: [ self pdmError: #missingDocumentationDirectory ].

	^ DocFileLibraryRepository new folder: ref.
]

{ #category : #baselines }
BaselineOfDocumentationSupport >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
			
		spec 
			package: 'DocumentationSupport';
			package: 'DocumentationSupport-UI';
			yourself
		].
]
