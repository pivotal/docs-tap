# NIST controls

This topic tells you about Tanzu Application Platform (commonly known as TAP) security control standard.

## <a id="controls"></a> Assessment of Tanzu Application Platform controls

Many organizations are required to reference a standardized control framework when assessing the security and compliance of their information systems.
Standardized control frameworks provide a model for how to protect information and data systems from threats, including malicious third parties, structural failures, and human error. One comprehensive and commonly referenced framework is [NIST Special Publication 800-53 Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final). Adherence to these controls is required for many government agencies in the United States, and for many private enterprises that operate within regulated markets, such as healthcare or finance. For example, the HIPAA regulations that govern the required protections for Personal Health Information (PHI) can be cross-referenced to the NIST SP 800-53 Rev. 5 control set.

This table provides a self-assessment of Tanzu Application Platform against the NIST SP 800-53 Rev. 5 controls and provides a high level of guidance for  the initial approch of how deployers can achieve compliance when using a shared responsibility model. Responsibility for any control can be assigned as indicated.

|Name | Developer Responability | Platform Provided (Tanzu Application Platform) | Hybrid (Platform and App shared resonsibility) | Potential to inharet from IaaS or Enterprise pollicy/tool | Security Control Baseline Moderate | Security Controle Baseline High |
|---|---|---|---|---|---|---|
| AC-1 | yes |  |  | yes | x | x |
| AC-2 | yes |  |  | yes | x | x |
| AC-2(1) |  | yes |  | yes | x | x |
| AC-2(2) | yes |  |  | yes | x | x |
| AC-2(3) |  yes |  |  | yes | x | x |
| AC-2(4) |  |  | yes |  | x | x |
| AC-2(5) | yes |  |  | yes | x | x |
| AC-2(7) |  |  |  | yes | x | x |
| AC-2(9) | yes |  |  | yes | x | x |
| AC-2(10) | yes |  |  | yes | x | x |
| AC-2(11) | yes |  |  | yes |  | x |
| AC-2(12) |   |  | yes | yes |  | x |
| AC-2(12)(a) |   |  | yes | yes |  |  |
| AC-2(12)(b) |   |  | yes | yes |  | x |
| AC-2(13) | yes |  |  | yes |  | x |
| AC-3 |  |  | yes | yes | x | x |
| AC-4 |  |  | yes |  | x | x |
| AC-5 |  | yes |  |  | x | x |
| AC-5a |  |  | yes |  | x | x |
| AC-5b |  |  | yes |  | x | x |
| AC-5c |  |  | yes |  | x | x |
| AC-6 |  | yes |  |  | x | x |
| AC-6 (1) | yes |  | yes | x | x |
| AC-6 (3) | yes |  | yes |  | x |
| AC-6 (5) |  |  | yes | yes | x | x |
| AC-7 |  |  | yes | yes | x | x |
| AC-7a | yes |  |  |  || x | x |
| AC-7b | yes |  |  |  | x | x |
| AC-11 | yes |  |  | yes | x | x |
| AC-11a | yes |  |  | yes |  |  |
| AC-11b | yes |  |  |  | x | x |
| AC-11 (1) | yes |  |  | yes | x | x |
| AC-12 | yes |  | ? |  | x | x |
| AC-12(1) | yes |  | ? |  |  |  |
| AC-14 |  |  | shared |  |  |  |
| AC-17 |  | yes |  |  | x | x |
| AC-17(1) |  | ? |  |  | x | x |
| AC-20 | yes |  |  | yes | x | x |
| AC-20(1) | yes |  |  | yes |  |  |
| AC-20(2) | yes |  |  | yes |  |  |
| AC-21 | yes |  |  | yes | x | x |
| AC-22 | yes |  |  | yes | x | x |
| AT-1 | yes |  |  | yes | x | x |
| AT-2 | yes |  |  | yes | x | x |
| AT-2 (1) | yes |  |  | yes | x | x |
| AT-2 (2) | yes |  |  | yes | x | x |
| AT-3 | yes |  |  | yes | x | x |
| AT-4 | yes |  |  | yes | x | x |
| AU-6(1) |  | ? |  |  | x | x |
| AU-6(3) | yes |  |  | yes | x | x |
| AU-6(5) | yes |  |  |  |  | x |
| AU-6(6) | yes |  |  |  |  | x |
| AU-6(7) | yes |  |  |  |  |  x|
| AU-7 |  | yes |  |  | x | x |
| AU-7a |  | yes |  |  | x | x |
| AU-7b |  |  |  |  | x | x |
| AU-7 (1) |  | yes |  |  | x | x |
| AU-9(2) | yes |  |  | yes |  |  |
| AU-11|  | ? |  | yes |  |  |
| AU-12 |  | yes |  |  | x | x |
| AU-12a |  | yes |  |  | x | x |
| AU-12b |  | yes |  |  | x | x |
| AU-12c |  | yes |  |  | x | x |
| AU-12(1) |  | yes |  |  |  | x |
| AU-12(3) |  | yes |  |  |  | x |
| CM-1 | yes |  |  | yes |  |  |
| CM-2 |  | yes |  |  |  |  |
| CM-2(1) |  | yes |  |  |  |  |
| CM-2(2) |  | yes |  |  |  |  |
| CM-2(3) |  | yes |  |  |  |  |
| CM-3(4) | yes |  |  |  |  |  |
| CM-3(5) |  |  | shared? | yes? |  |  |
| CM-4 | yes |  |  |  |  |  |
| CM-4(1) | yes |  |  |  |  |  |
| CM-5 |  |  | shared |  |  |  |
| CM-5(1) |  | roadmap? |  |  |  |  |
| CM-5(2) |  |  | Shared |  |  |  |
| CM-6 |  |  | yes |  | x | x |
| CM-6(1) |  |  | yes |  |  | x |
| CM-7 |  | yes |  |  | x | x |
| CM-7(2) |  |  | yes |  | x | x |
| CM-7(4) | yes |  |  | yes | x |  |
| CM-7(4)(a) | yes |  |  |  |  |  |
| CM-7(4)(b) | yes |  |  | yes | x |  |
| CM-7(5) | yes |  |  |  |  |  |
| CM-7(5)(b) | yes |  |  | yes |  | x |
| CM-8 |  | yes | ? |  |  |  |
| CM-8(1) |  | yes |  |  |  |  |
| CM-8(2) |  | yes |  |  |  |  |
| CM-8(3) |  | yes |  |  |  |  |
| CM-10 | yes |  |  |  |  |  |
| CP-1 | yes |  |  | yes | x | x |
| CP-1a |  |  |  | yes |  |  |
| CP-1a1 |  |  |  | yes |  |  |
| CP-1 a2|  |  |  | yes |  |  |
| CP-1b |  |  |  | yes |  |  |
| CP-1b1 |  |  |  | yes |  |  |
| CP-1 b2|  |  |  | yes |  |  |
| CP-2 | yes |  |  | yes | x | x |
| CP-2a |  |  |  | yes |  |  |
| CP-2a1 |  |  |  | yes |  |  |
| CP-2a2 |  |  |  | yes |  |  |
| CP-2a3 |  |  |  | yes |  |  |
| CP-2a4 |  |  |  | yes |  |  |
| CP-2a6 |  |  |  | yes |  |  |
| CP-2b |  |  |  | yes |  |  |
| CP-2c |  |  |  | yes |  |  |
| CP-2d |  |  |  | yes |  |  |
| CP-2e |  |  |  | yes |  |  |
| CP-2f |  |  |  | yes |  |  |
| CP-2g |  |  |  | yes |  |  |
| CP-2 (1) | yes |  |  | yes | x | x |
| CP-2 (2) | yes |  |  | yes |  | x |
| CP-2 (3) | yes |  |  | yes | x | x |
| CP-2 (4) | yes |  |  | yes |  | x |
| CP-2 (5) | yes |  |  | yes |  | x |
| CP-2 (6) | yes |  |  | yes |  |  |
| CP-2 (7) | yes |  |  | yes |  |  |
| CP-2 (8) | yes |  |  | yes | x | x |
| CP-3 | yes |  |  | yes | x | x |
| CP-3a | yes |  |  | yes |  |  |
| CP-3b | yes |  |  | yes |  |  |
| CP-3c | yes |  |  | yes |  |  |
| CP-3 (1) | yes |  |  | yes |  | x |
| CP-3 (2) | yes |  |  | yes |  |  |
| CP-4 | yes |  |  | yes | x | x |
| CP-4a | yes |  |  | yes |  |  |
| CP-4b | yes |  |  | yes |  |  |
| CP-4c | yes |  |  | yes |  |  |
| CP-4 (1) | yes |  |  | yes | x | x |
| CP-4 (2) | yes |  |  | yes |  | x |
| CP-4(2)(a) | yes |  |  | yes |  |  |
| CP-4(2)(b) | yes |  |  | yes |  |  |
| CP-4 (3) | yes |  |  | yes |  |  |
| CP-4 (4) | yes |  |  | yes |  |  |
| CP-5 | yes |  |  | yes |  |  |
| CP-6| yes |  |  | yes | x | x |
| CP-6a| yes |  |  | yes |  |  |
| CP-6b| yes |  |  | yes |  |  |
| CP-6 (1) | yes |  |  | yes | x | x |
| CP-6 (2) | yes |  |  | yes |  | x |
| CP-6 (3) | yes |  |  | yes | x | x |
| CP-7 | yes |  |  | yes | x | x |
| CP-7a | yes |  |  | yes |  |  |
| CP-7b | yes |  |  | yes |  |  |
| CP-7c | yes |  |  | yes |  |  |
| CP-7 (1) | yes |  |  | yes | x | x |
| CP-7 (2) | yes |  |  | yes | x | x |
| CP-7 (3) | yes |  |  | yes | x | x |
| CP-7 (4) | yes |  |  | yes |  | x |
| CP-7 (5) | yes |  |  | yes |  |  |
| CP-7 (6) | yes |  |  | yes |  |  |
| CP-8 | yes |  |  | yes | x | x |
| CP-8(1) | yes |  |  | yes | x | x |
| CP-8(1)(a) | yes |  |  | yes |  |  |
| CP-8(1)(b) | yes |  |  | yes |  |  |
| CP-8(2) | yes |  |  | yes | x | x |
| CP-8(3) | yes |  |  | yes |  | x |
| CP-8(4) | yes |  |  | yes |  | x |
| CP-8(4)(a) | yes |  |  | yes |  |  |
| CP-8(4)(b) | yes |  |  | yes |  |  |
| CP-8(4)(c) | yes |  |  | yes |  |  |
| CP-8(5) |  |  |  | yes |  |  |
| CP-9 | yes |  |  | yes |  | x | x |
| CP-9a |  |  |  | yes |  |  |  |
| CP-9b |  |  |  | yes |  |  |  |
| CP-9c |  |  |  | yes |  |  |  |
| CP-9d |  |  |  | yes |  |  |  |
| CP-9 (1) | yes |  |  | yes |  | x | x |
| CP-9 (2) | yes |  |  | yes |  |  | x |
| CP-9 (3) | yes |  |  | yes |  |  | x |
| CP-9 (4) | yes |  |  | yes |  |  | x |
| CP-9 (5) | yes? |  |  | yes |  |  | x |
| CP-9(6) |  |  |  | yes |  |  | x |
| CP-9(7) |  |  |  | yes |  |  | x |
| CP-10 |  |  | yes |  | x | x |
| CP-10 (1) |  |  | yes | x | x |
| CP-10 (2) |  |  | yes | x | x |
| CP-10 (3) |  |  | yes | x | x |
| CP-10 (4) |  |  | yes | x | x |
| IA-1 | yes |  |  |  | x | x |
| IA-2 |  | yes |  | yes | x | x |
| IA-2(2) |  |  | yes |  | x | x |
| IA-2(3) | yes |  |  | yes |  |  |
| IA-2(4) |  | yes |  | yes |  | x |
| IA-2(9) |  | yes |  | yes |  | x |
| IA-2(11) |  | yes |  | yes | x | x |
| IA-2(12) |  | yes |  | yes | x | x |
| IA-3 |  |  | yes | yes | x | x |
| IA-4 |  | yes |  | yes | x | x |
| IA-4a |  | yes |  | yes | x | x |
| IA-4b |  | yes |  | yes | x | x |
| IA-4c |  | yes |  | yes | x | x |
| IA-4d |  | yes |  | yes | x | x |
| IA-5 | yes |  |  | yes | x | x |
| IA-5(1) | yes |  |  | yes | x | x |
| IA-5(1)(a) | yes |  |  | yes | x | x |
| IA-5(1)(d) | yes |  |  | yes | x | x |
| IA-5(1)(e) | yes |  |  | yes | x | x |
| IA-5(1)(f) | yes |  |  | yes | x | x |
| IA-5 (11) |  |  |  | yes | x | x |
| IA-6 | yes |  |  | yes | x | x |
| IA-7 | yes |  |  | yes | x | x |
| IA-8 |  |  | yes |  | x | x |
| IA-8(3) | yes |  |  | yes | x | x |
| IR-1 | yes |  |  | yes | x | x |
| IR-2 | yes |  |  | yes | x | x |
| IR-2 (1) | yes |  |  | yes |  | x |
| IR-2 (2) | yes |  |  | yes |  | x |
| IR-3 | yes |  |  | yes | x | x |
| IR-3 (1) | yes |  |  | yes | x | x |
| IR-3 (2) | yes |  |  | yes | x | x |
| IR-4 | yes |  |  | yes | x | x |
| IR-4(1) | yes |  |  | yes | x | x |
| IR-4(2) | yes |  |  | yes | x |  |
| IR-4(3) |  |  |  | yes |  | x |
| IR-4(4) | yes |  |  | yes |  | x |
| IR-5 |  |  | yes |  | x | x |
| IR-5 (1) |  |  | yes |  |  | x |
| IR-6 | yes |  |  | yes | x | x |
| IR-6 (1) | yes |  |  | yes | x | x |
| IR-7 | yes |  |  | yes | x | x |
| IR-7 (1) | yes |  |  | yes | x | x |
| IR-8 | yes |  |  | yes | x | x |
| MA-1 | yes |  |  | yes | x | x |
| MA-2 | yes |  |  | yes | x | x |
| MA-3 | yes |  |  | yes | x | x |
| MA-3(1) | yes |  |  | yes | x | x |
| MA-3(2) | yes |  |  | yes | x | x |
| MA-3(3) | yes |  |  | yes | x | x |
| MA-4 | yes |  |  | yes | x | x |
| MA-4(2) |yes |  |  | yes | x | x |
| MA-4(3) |yes |  |  | yes | x | x |
| MA-5 |yes |  |  | yes | x | x |
| MA-5(1) |yes |  |  | yes | x | x |
| MA-6 |yes |  |  | yes | x | x |
| MP-1 |yes |  |  | yes | x | x |
| MP-2 |yes |  |  | yes | x | x |
| MP-3 |yes |  |  | yes | x | x |
| MP-4 |yes |  |  | yes | x | x |
| MP-5 |yes |  |  | yes | x | x |
| MP-5 (4) |yes |  |  | yes | x | x |
| MP-6 |yes |  |  | yes | x | x |
| MP-6(1) | yes |  |  | yes |  | x |
| MP-6(2) | yes |  |  | yes |  | x |
| MP-6(3) | yes |  |  | yes |  | x |
| MP-7 |yes |  |  | yes | x | x |
| MP-7(1) |yes |  |  | yes | x | x |
| PE-1 |yes |  |  | yes | x | x |
| PE-2 |yes |  |  | yes | x | x |
| PE-3 |yes |  |  | yes | x | x |
| PE-3(1) | yes |  |  | yes |  | x |
| PE-4 |yes |  |  | yes | x | x |
| PE-5 |yes |  |  | yes | x | x |
| PE-6 |yes |  |  | yes | x | x |
| PE-6(1) |yes |  |  | yes | x | x |
| PE-6(4) | yes |  |  | yes |  | x |
| PE-8 |yes |  |  | yes | x | x |
| PE-8(1) | yes |  |  | yes |  | x |
| PE-9 |yes |  |  | yes | x | x |
| PE-10 |yes |  |  | yes | x | x |
| PE-11 |yes |  |  | yes | x | x |
| PE-12 |yes |  |  | yes | x | x |
| PE-13 |yes |  |  | yes | x | x |
| PE-13(1) | yes |  |  | yes |  | x |
| PE-13(2) | yes |  |  | yes |  | x |
| PE-13(3) | yes |  |  | yes | x | x |
| PE-14 |yes |  |  | yes | x | x |
| PE-15 |yes |  |  | yes | x | x |
| PE-15(1) | yes |  |  | yes |  | x |
| PE-16 |yes |  |  | yes | x | x |
| PE-17 |yes |  |  | yes | x | x |
| PE-18 | yes |  |  | yes |  | x |
| PL-1 |yes |  |  | yes | x | x |
| PL-2 |yes |  |  | yes | x | x |
| PL-2(3) |yes |  |  | yes | x | x |
| PL-4 |yes |  |  | yes | x | x |
| PL-4 (1) |yes |  |  | yes | x | x |
| PL-8 |  |  | yes |  | x | x |
| PS-1 |yes |  |  | yes | x | x |
| PS-2 |yes |  |  | yes | x | x |
| PS-3 | yes |  |  | yes | x | x |
| PS-4 | yes |  |  | yes | x | x |
| PS-4(2) | yes |  |  | yes |  | x |
| PS-5 | yes |  |  | yes | x | x |
| PS-6 | yes |  |  | yes | x | x |
| PS-7 | yes |  |  | yes | x | x |
| PS-8 | yes |  |  | yes | x | x |
| RA-1 | yes |  |  | yes | x | x |
| RA-2 | yes |  |  | yes | x | x |
| RA-3 | yes |  |  | yes | x | x |
| RA-5 |  |  | yes |  | x | x |
| RA-5(1) |  |  | yes |  | x | x |
| RA-5(2) |  |  | yes |  | x | x |
| RA-5(4) |  |  | yes |  |  | x |
| RA-5(5) |  |  | yes |  | x | x |
| RA-7 |  |  | yes |  | x | x |
| RA-9 |yes |  |  | yes | x | x |
| SA-1 |yes |  |  | yes | x | x |
| SA-2 |yes |  |  | yes | x | x |
| SA-3 |yes |  |  | yes | x | x |
| SA-4 |yes |  |  | yes | x | x |
| SA-4(1) |yes |  |  | yes | x | x |
| SA-4(2) |yes |  |  | yes | x | x |
| SA-4 (9)  |yes |  |  | yes | x | x |
| SA-4 (10) |yes |  |  | yes | x | x |
| SA-5 |yes |  |  | yes | x | x |
| SA-8 |yes |  |  | yes | x | x |
| SA-9 |yes |  |  | yes | x | x |
| SA-9(2) |yes |  |  | yes | x | x |
| SA-10 |yes |  |  | yes | x | x |
| SA-11 |yes |  |  | yes | x | x |
| SA-12 | yes |  |  | yes |  | x | x |
| SA-15 | yes |  |  | yes |  | x |
| SA-16 | yes |  |  | yes |  | x |
| SA-17 | yes |  |  | yes |  | x |
| SA-21 | yes |  |  | yes |  |  |
| SA-22 |  |  | yes |  |  |  |
| SC-1 |yes |  |  | yes | x | x |
| SC-2 |  |  | yes |  | x | x |
| SC-3 |  |  | yes |  |  | x |
| SC-4 |  | yes |  |  | x | x |
| SC-5 |  | yes |  |  | x | x |
| SC-7 |  | yes |  |  | x | x |
| SC-7a |  |  | yes |  | x | x |
| SC-7b |  |  | yes |  | x | x |
| SC-7c |yes |  |  | yes | x | x |
| SC-7(4)(c) |  | yes |  |  | x | x |
| SC-7(5) |  | yes |  |  | x | x |
| SC-7(7) | yes |  |  |  |  |  |
| SC-7(8) |  | coming soon |  |  |  | x |
| SC-7(18) |  | yes |  | yes |  | x |
| SC-8 |  | yes |  | yes | x | x |
| SC-10 |  | yes |  | yes | x | x |
| SC-12 |yes |  |  | yes | x | x |
| SC-13 |yes |  |  | yes | x | x |
| SC-15 |yes |  |  | yes | x | x |
| SC-17 |yes |  |  | yes | x | x |
| SC-18 |yes |  |  | yes | x | x |
| SC-19 |yes |  |  | yes | x | x |
| SC-20 |yes |  |  | yes | x | x |
| SC-21 |  | yes |  |  | x | x |
| SC-22 |  |  | yes |  | x | x |
| SC-23 |  |  | yes |  | x | x |
| SC-24 | yes |  |  | yes |  | x |
| SC-28 |yes |  |  | yes | x | x |
| SC-39 |  | yes |  |  | x | x |
| SI-1 |yes |  |  | yes | x | x |
| SI-2 |  |  | yes |  | x | x |
| SI-3 |  |  | yes |  | x | x |
| SI-4 |  |  | yes |  | x | x |
| SI-5 |  |  | yes |  | x | x |
| SI-6 |  |  | yes |  |  | x |
| SI-6a |  |  | yes |  |  | x |
| SI-6b |  |  | yes |  |  | x |
| SI-6c |  |  | yes |  |  | x |
| SI-6d |  |  | yes |  |  | x |
| SI-7 |yes |  |  | yes | x | x |
| SI-7(1) |yes |  |  | yes | x | x |
| SI-7(2) | yes |  |  | yes |  | x |
| SI-7(5) | yes |  |  | yes |  | x |
| SI-8 |yes |  |  | yes | x | x |
| SI-10 |yes |  |  | yes | x | x |
| SI-11 |yes |  |  | yes | x | x |
| SI-12 |yes |  |  | yes | x | x |
| SI-16 |  | yes |  |  | x | x |
| SR-1 |yes |  |  | yes | x | x |
| SR-2 |yes |  |  | yes | x | x |
| SR-2(1) |yes |  |  | yes | x | x |
| SR-3 |yes |  |  | yes | x | x |
| SR-5 |yes |  |  | yes | x | x |
| SR-6 |yes |  |  | yes | x | x |
| SR-8 |  |  | yes |  | x | x |
| SR-9 |  |  | yes |  |  | x |
| S9-9(1) |  |  | yes |  |  | x |
| SR-10 |yes |  |  | yes | x | x |
| SR-11 |yes |  |  | yes | x | x |
| SR-11(1) |yes |  |  | yes | x | x |
| SR-11(2) |  | yes |  |  | x | x |
