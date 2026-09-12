#import "src/styles.typ": text-document
#import "src/utils.typ": icon, note, reset-enum, no-indent, formatted-table

// Импорт структурных элементов текстового документа по ГОСТ Р 2.105-2019
#import "src/components/titlepage.typ": titlepage
#import "src/components/contents.typ": contents
#import "src/components/abbreviations.typ": abbreviations
#import "src/components/appendixes.typ": appendixes
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

// Разделы Руководства по комплексу средств защиты информации
#let startup_description = include "src/content/startup_description.typ"
#let security_testing = include "src/content/security_testing.typ"
#let integrity_maintenance = include "src/content/integrity_maintenance.typ"
#let security_measures = include "src/content/security_measures.typ"
#let system_restrictions = include "src/content/system_restrictions.typ"
