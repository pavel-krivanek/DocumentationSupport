Class {
	#name : #ClyDocumentationSupportMorph,
	#superclass : #ClyBrowserToolMorph,
	#category : #'DocumentationSupport-Calypso'
}

{ #category : #activation }
ClyDocumentationSupportMorph class >> browserTabActivationClass [
	"This declaration specifies that in any browser when methods are selected, a diff tool will be available in a tab."

	<classAnnotation>
	^ClyTabActivationStrategyAnnotation for: ClyClass asCalypsoItemContext
]

{ #category : #activation }
ClyDocumentationSupportMorph class >> browserTabActivationMethod [
	"This declaration specifies that in any browser when methods are selected, a diff tool will be available in a tab."

	<classAnnotation>
	^ClyTabActivationStrategyAnnotation for: ClyMethod asCalypsoItemContext
]

{ #category : #activation }
ClyDocumentationSupportMorph class >> browserTabActivationPackage [
	"This declaration specifies that in any browser when methods are selected, a diff tool will be available in a tab."

	<classAnnotation>
	^ClyTabActivationStrategyAnnotation for: RPackage asCalypsoItemContext
]

{ #category : #activation }
ClyDocumentationSupportMorph class >> shouldBeActivatedInContext: aBrowserContext [

	DocLibrary browserNavigates: (aBrowserContext selectedItems collect: #actualObject).

	(DocLibrary libraries flatCollect: #books) flatCollect: [ :each | 
		each classesAndCompiledMethodsOverChaptersBidirectionalDictionary associations ].
	
	^ false
]

{ #category : #building }
ClyDocumentationSupportMorph >> build [
	self context traceCr
]
