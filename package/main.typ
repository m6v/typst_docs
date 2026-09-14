#import "src/styles.typ": text-document
#import "src/utils.typ": icon, note, reset-enum, no-indent, formatted-table

// Импорт структурных элементов текстового документа по ГОСТ Р 2.105-2019
#import "src/components/titlepage.typ": titlepage
#import "src/components/contents.typ": contents
#import "src/components/abbreviations.typ": abbreviations
#import "src/components/appendixes.typ": appendixes, appendix
#import "src/components/changelog.typ": changelog

// Описание средств ЗИ, порядка их установки и применения
#let sobol_description = include "src/content/sobol_description.typ"
#let sobol_install = include "src/content/sobol_install.typ"
#let sobol_applying = include "src/content/sobol_applying.typ"

#let astra_description = include "src/content/astra_description.typ"
#let astra_install = include "src/content/astra_install.typ"
#let astra_applying = include "src/content/astra_applying.typ"

#let kpsgp_description = include "src/content/kpsgp_description.typ"
#let kpsgp_install = include "src/content/kpsgp_install.typ"
#let kpsgp_applying = include "src/content/kpsgp_applying.typ"

#let drweb_description = include "src/content/drweb_description.typ"
#let drweb_install = include "src/content/drweb_install.typ"

#let jacarta_description = include "src/content/jacarta_description.typ"
#let jacarta_install = include "src/content/jacarta_install.typ"
#let jacarta_applying = include "src/content/jacarta_applying.typ"

#let dionis-nx_description = include "src/content/dionis-nx_description.typ"
//#let dionis-nx_install = include "src/content/dionis-nx_install.typ"
#let dionis-nx_applying = include "src/content/dionis-nx_applying.typ"

#let rebus-sov_description = include "src/content/rebus-sov_description.typ"
//#let rebus-sov_install = include "src/content/rebus-sov_install.typ"
#let rebus-sov_applying = include "src/content/rebus-sov_applying.typ"

#let strom-1000_description = include "src/content/strom-1000_description.typ"
//#let strom-1000_install = include "src/content/strom-1000_install.typ"
#let strom-1000_applying = include "src/content/strom-1000_applying.typ"

#let scaner-vs_description = include "src/content/scaner-vs_description.typ"
//#let scaner-vs_install = include "src/content/scaner-vs_install.typ"
#let scaner-vs_applying = include "src/content/scaner-vs_applying.typ"

#let m-479rk_description = include "src/content/m-479rk_description.typ"
//#let m-479rk_install = include "src/content/m-479rk_install.typ"
//#let m-479rk_applying = include "src/content/m-479rk_applying.typ"

#let kontinent_description = include "src/content/kontinent_description.typ"
//#let kontinent_install = include "src/content/kontinent_install.typ"
//#let kontinent_applying = include "src/content/kontinent_applying.typ"

#let cryptopro_description = include "src/content/cryptopro_description.typ"
//#let cryptopro_install = include "src/content/cryptopro_install.typ"
#let cryptopro_applying = include "src/content/cryptopro_applying.typ"


// Разделы Руководства по комплексу средств защиты информации
#let startup_description = include "src/content/startup_description.typ"
#let security_testing = include "src/content/security_testing.typ"
#let integrity_maintenance = include "src/content/integrity_maintenance.typ"
#let security_measures = include "src/content/security_measures.typ"
#let emergency_destruction = include "src/content/emergency_destruction.typ"
#let system_restrictions = include "src/content/system_restrictions.typ"
