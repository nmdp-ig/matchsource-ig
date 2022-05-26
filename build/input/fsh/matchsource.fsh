Profile:  MSPatient
Parent:   Patient
Id:       mspatient
Description: "Patient needing a transplant"
* name 1..* MS
* name.given 1..* MS
* name.family 1..1 MS
* gender 1..1 MS
* birthDate 1..1 MS
* address 1..1 MS
* address.line 1..* MS
* address.country 1..1 MS
* address.city 1..1 MS
* address.state 1..1 MS
* address.postalCode 1..1 MS
* communication 0..* MS
* telecom 0..1 MS 
* telecom.value 1..1 MS
* telecom.system 1..1 MS 
* telecom.system = #phone
* generalPractitioner 0..1 MS
* generalPractitioner only Reference(transplantcentercoordinator)
* identifier 0..1 MS
* managingOrganization 0..1 MS
* managingOrganization only Reference(transplantcenter)
* extension contains 
    $us-core-race named race 0..1 MS and
    $us-core-ethnicity named ethnicity 0..1 MS and
    nmdp-race named nmdprace 0..1 MS
* obeys rac-1

Instance: MSPatientExample
InstanceOf: MSPatient
Description: "An example of a patient needing a donor using us-core-race code."
* name
  * given[0] = "Jane"
  * family = "Everyperson"
* gender = #female
* birthDate = "1974-12-25"
* address.line[0] = "123 Main St"
* address.country = "USA"
* address.city = "Minneapolis"
* address.state = "MN"
* address.postalCode = "55401"
* telecom[0].value = "1-612-555-1234"
* extension[race].extension[ombCategory].valueCoding = $RaceAndEthnicityCDC#2106-3 "White"
* extension[race].extension[text].valueString = "White"
* extension[ethnicity].extension[ombCategory].valueCoding = $RaceAndEthnicityCDC#2186-5 "Non Hispanic or Latino"
* extension[ethnicity].extension[text].valueString = "Non Hispanic or Latino"

Instance: MSPatientExample2
InstanceOf: MSPatient
Description: "An example of a patient needing a donor using NMDP race code."
* name
  * given[0] = "Joe"
  * family = "Everyperson"
* gender = #male
* birthDate = "1974-12-25"
* address.line[0] = "123 Main St"
* address.country = "USA"
* address.city = "Minneapolis"
* address.state = "MN"
* address.postalCode = "55401"
* telecom[0].value = "1-612-555-1234"
* extension[nmdprace].valueCodeableConcept.coding = $NMDPRace#EURWRC "North American or European"

Instance: MSPatientExample3
InstanceOf: MSPatient
Description: "An example of a patient without a race code - this should generate an error."
* name
  * given[0] = "Jason"
  * family = "Everyperson"
* gender = #male
* birthDate = "1974-12-25"
* address.line[0] = "123 Main St"
* address.country = "USA"
* address.city = "Minneapolis"
* address.state = "MN"
* address.postalCode = "55401"
* telecom[0].value = "1-612-555-1234"

Instance: MSPatientExample4
InstanceOf: MSPatient
Description: "An example of a patient needing a donor using us-core-race code but not us-core-ethnicity - this should generate an error"
* name
  * given[0] = "Jona"
  * family = "Everyperson"
* gender = #male
* birthDate = "1974-12-25"
* address.line[0] = "123 Main St"
* address.country = "USA"
* address.city = "Minneapolis"
* address.state = "MN"
* address.postalCode = "55401"
* telecom[0].value = "1-612-555-1234"
* extension[race].extension[ombCategory].valueCoding = $RaceAndEthnicityCDC#2106-3 "White"
* extension[race].extension[text].valueString = "White"


Profile: TransplantCenter
Parent: Organization
Id:     transplantcenter
Description: "Transplant Center"
// contains transplantCenterEnterpriseId
* identifier 1..* MS

Instance: TCExample
InstanceOf: transplantcenter
Description: "An example of a Transplant Center."
* name = "My Transplant Center"
* identifier.system = "http://terminology.nmdp.org/identifier/transplantcenter"
* identifier.value = "000"

Profile: MSSpecimen
Parent: Specimen
Id:     msspecimen
Description: "Patient Sample"
// TC Sample ID
// for HLA report?
* identifier 1..* MS
* subject 1..1 MS
* subject only Reference(mspatient)

Instance: MSSpecimenExample
InstanceOf: MSSpecimen
Description: "An example patient specimen."
* identifier.system = "http://terminology.nmdp.org/identifier/transplantcenter"
* identifier.value = "000"
* subject = Reference(MSPatientExample)

Profile: TransplantCenterCoordinator
Parent: Practitioner
Id: transplantcentercoordinator
Description: "Transplant Center Coordinator"
* name 1..1 MS
* name.given 1..* MS
* name.family 1..1 MS

Instance: CoordinatorExample
InstanceOf: transplantcentercoordinator
Description: "An example of a Transplant Center Coordinator."
* name
  * given[0] = "Jill"
  * family = "Doe"

Profile: MSDiagnosis
Parent: Condition
Id: msdiagnosis
Description: "Diagnosis"
* code 1..1 MS
* code from nmdp-disease-codes (required)
* subject 1..1 MS
* subject only Reference(mspatient)
* recordedDate 1..1 MS

Instance: MSDiagnosisExample
InstanceOf: msdiagnosis
Description: "Example of a Diagnois"
* code.coding[0].system = "http://terminology.nmdp.org/codesystem/disease"
* code.coding[0].code = #OND
* code.coding[0].display = "OTHER NON-MALIGNANT DISEASE"
* subject = Reference(MSPatientExample)
* recordedDate = "2021-11-01"


Extension: NMDPRace
Id: nmdp-race
Title: "NMDP Race Code Extension"
Description: "Extension to use NMDP Race Codes"
* value[x] only CodeableConcept
* valueCodeableConcept.coding.code from NMDPRaceCodes (required)

Invariant: rac-1
Severity: #error
Description: "Shall use either NMDP Race extension or us-core-race"
// Expression: "extension[nmdprace].exists() or extension[race].exists()"
// Expression: "extension.exists(url = 'http://fhir.nmdp.org/ig/matchsource/StructureDefinition/nmdp-race') or extension.exists(url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race')"
Expression: "extension.exists(url = 'http://fhir.nmdp.org/ig/matchsource/StructureDefinition/nmdp-race') or (extension.exists(url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity')) and extension.exists(url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race')"
// Expression: "extension.exists(url = 'http://fhir.nmdp.org/ig/matchsource/StructureDefinition/nmdp-race' or (url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity' and url = 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'))"
