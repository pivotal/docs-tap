# NIST Controls

This topic reviews Tanzu Application Platform security control standards.

## <a id="controls"></a> Assessment of Tanzu Application Platform Controls

Many organizations are required to reference a standardized control framework when assessing the security and compliance of their information systems.
Standardized control frameworks provide a model for how to protect information and data systems from threats, including malicious third parties, structural failures, and human error. One comprehensive and commonly referenced framework is [NIST Special Publication 800-53 Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final). Adherence to these controls is required for many government agencies in the United States, and for many private enterprises that operate within regulated markets, such as healthcare or finance. For example, the HIPAA regulations that govern the required protections for Personal Health Information (PHI) can be cross-referenced to the NIST SP 800-53 Rev. 5 control set.

This table provides a self-assessment of the Tanzu Application Platform against the NIST SP 800-53 Rev. 5 controls and provides a high level of guidance for  the initial approch of how deployers may achieve compliance when using a shared responsibility model. Responsibility for any control may be assigned as indicated.

|Name | Developer Responability | Platform Provided (Tanzu Application Platform) | Hybrid (Platform and App shared resonsibility) | Potential to inharet from IaaS or Enterprise pollicy/tool | Security Control Baseline Moderate | Security Controle Baseline High |
|-|-|-|-|-|-|-|
| AC-1 | yes |  |  | yes | x | x |
| AC-2 | yes |  |  | yes | x | x |
| AC-2(1) |  | yes |  | yes | x | x |
| AC-2(2) | yes |  |  | yes | x | x |
| AC-2(3) |  yes |  |  | yes | x | x |
| AC-2(4) |  |  | yes |  | x | x |
| AC-2(5) | yes |  |  | yes | x | x |
| AC-2(6) |  |  |  |  |  |  |
| AC-2(7) |  |  |  | yes | x | x |
| AC-2(7) |  |  |  |  |  |  |
| AC-2(7)(a) |  |  |  |  |  |  |
| AC-2(7)(b) |  |  |  |  |  |  |
| AC-2(7)(c) |  |  |  |  |  |  |
| AC-2(8) |  |  |  |  |  |  |
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
| AC-12(1)(a) |  |  |  |  |  |  |
| AC-12(1)(b) |  |  |  |  |  |
| AC-13 |  |  |  |  |  |  |
| AC-14 |  |  | shared |  |  |  |
| AC-14a |  |  |  |  |  |  |
| AC-14b |  |  |  |  |  |  |
| AC-14(1) |  |  |  |  |  |  |
| AC-15 |  |  |  |  |  |  |
| AC-16 |  |  |  |  |  |  |
| AC-16a |  |  |  |  |  |  |
| AC-16b |  |  |  |  |  |  |
| AC-16c |  |  |  |  |  |  |
| AC-16 |  |  |  |  |  |  |
| AC-16(1) |  |  |  |  |  |  |
| AC-16(2) |  |  |  |  |  |  |
| AC-16(3) |  |  |  |  |  |  |
| AC-16(4) |  |  |  |  |  |  |
| AC-16(5) |  |  |  |  |  |  |
| AC-16(6) |  |  |  |  |  |  |
| AC-16(7) |  |  |  |  |  |  |
| AC-16(8) |  |  |  |  |  |  |
| AC-16(9) |  |  |  |  |  |  |
| AC-16(10) |  |  |  |  |  |  |
| AC-17 |  | yes |  |  | x | x |
| AC-17a |  |  |  |  |  |  |
| AC-17b |  |  |  |  |  |  |
| AC-17(1) |  | ? |  |  | x | x |
| AC-17(2) |  |  |  |  |  |  |
| AC-17(3) |  |  |  |  |  |  |
| AC-17(4) |  |  |  |  |  |  |
| AC-17(4)(a) |  |  |  |  |  |  |
| AC-17(4)(b) |  |  |  |  |  |  |
| AC-17(5) |  |  |  |  |  |  |
| AC-17(6) |  | ? |  |  |  |  |
| AC-17(7) |  |  |  |  |  |  |
| AC-17(8) |  |  |  |  |  |  |
| AC-17(9) |  | ? |  |  |  |  |
| AC-18	n/a |  |  |  |  |  |  |
| AC-18a |  |  |  |  |  |  |
| AC-18b |  |  |  |  |  |  |
| AC-18(1) |  |  |  |  |  |  |
| AC-18(2) |  |  |  |  |  |  |
| AC-18(3) |  |  |  |  |  |  |
| AC-18(4) |  |  |  |  |  |  |
| AC-18(5) |  |  |  |  |  |  |
| AC-19 | n/a |  |  |  |  |  |
| AC-19a | n/a |  |  |  |  |  |
| AC-19b | n/a |  |  |  |  |  |
| AC-19(1) |  |  |  |  |  |  |
| AC-19(2) |  |  |  |  |  |  |
| AC-19(3) |  |  |  |  |  |  |
| AC-19(4) |  |  |  |  |  |  |
| AC-19(4)(a) |  |  |  |  |  |  |
| AC-19(4)(b) |  |  |  |  |  |  |
| AC-19(4)(b)(1) |  |  |  |  |  |  |
| AC-19(4)(b)(2) |  |  |  |  |  |  |
| AC-19(4)(b)(3) |  |  |  |  |  |  |
| AC-19(4)(b)(4) |  |  |  |  |  |  |
| AC-19(4)(c) |  |  |  |  |  |  |
| AC-19(5) |  |  |  |  |  |  |
| AC-20 | yes |  |  | yes | x | x |
| AC-20a |  |  |  |  |  |  |
| AC-20b |  |  |  |  |  |  |
| AC-20(1) | yes |  |  | yes |  |  |
| AC-20(1)(a) |  |  |  |  |  |  |
| AC-20(1)(b) |  |  |  |  |  |  |
| AC-20(2) | yes |  |  | yes |  |  |
| AC-20(3) |  |  |  |  |  |  |
| AC-20(4) |  |  |  |  |  |  |
| AC-21 | yes |  |  | yes | x | x |
| AC-21a |  |  |  |  |  |  |
| AC-21b |  |  |  |  |  |  |
| AC-21(1) |  |  |  |  |  |  |
| AC-21(2) |  |  |  |  |  |  |
| AC-22 | yes |  |  | yes | x | x |
| AC-22a |  |  |  |  |  |  |
| AC-22b |  |  |  |  |  |  |
| AC-22c |  |  |  |  |  |  |
| AC-22d |  |  |  |  |  |  |
| AC-23 |  |  |  |  |  |  |
| AC-24 |  |  |  |  |  |  |
| AC-24(1) |  |  |  |  |  |  |
| AC-24(2) |  |  |  |  |  |  |
|AC-25 |  |  |  |  |  |  |
| AT-1 | yes |  |  | yes | x | x |
| AT-1a |  |  |  |  |  |  |
| AT-1a1 |  |  |  |  |  |  |
| AT-1a2 |  |  |  |  |  |  |
| AT-1b |  |  |  |  |  |  |
| AT-1b1 |  |  |  |  |  |  |
| AT-1b2 |  |  |  |  |  |  |
| AT-2 | yes |  |  | yes | x | x |
| AT-2a |  |  |  |  |  |  |
| AT-2b |  |  |  |  |  |  |
| AT-2c |  |  |  |  |  |  |
| AT-2 (1) | yes |  |  | yes | x | x |
| AT-2 (2) | yes |  |  | yes | x | x |
| AT-3 | yes |  |  | yes | x | x |
| AT-3a |  |  |  |  |  |  |
| AT-3b |  |  |  |  |  |  |
| AT-3c |  |  |  |  |  |  |
| AT-3(1) |  |  |  |  |  |  |
| AT-3(2) |  |  |  |  |  |  |
| AT-3(3) |  |  |  |  |  |  |
| AT-3(4) |  |  |  |  |  |  |
| AT-4 | yes |  |  | yes | x | x |
| AT-4a |  |  |  |  |  |  |
| AT-4b |  |  |  |  |  |  |
| AT-5 |  |  |  |  |  |  |
| AU-1 |  |  | shared |  |  |  |
| AU-1a |  |  |  |  |  |  |
| AU-1a1 |  |  |  |  |  |  |
| AU-1a2 |  |  |  |  |  |  |
| AU-1b |  |  |  |  |  |  |
| AU-1b1 |  |  |  |  |  |  |
| AU-1b2 |  |  |  |  |  |  |
| AU-2 |  |  | shared |  |  |  |
| AU-2a |  |  |  |  |  |  |
| AU-2b |  |  |  |  |  |  |
| AU-2c |  |  |  |  |  |  |
| AU-2d |  |  |  |  |  |  |
| AU-2(1) |  |  |  |  |  |  |
| AU-2(2) |  |  |  |  |  |  |
| AU-2(3) |  | ???? |  |  |  |  |
| AU-2(4) |  |  |  |  |  |  |
| AU-3 |  |  | shared |  |  |  |
| AU-3(1) |  |  | shared |  |  |  |
| AU-3(2) |  | ? |  |  |  |  |
| AU-4 |  | ? |  |  |  |  |
| AU-4(1) |  | ? |  |  |  |  |
| AU-5a |  |  |  |  |  |  |
| AU-5b |  |  |  |  |  |  |
| AU-5(1) |  | ? |  |  |  |  |
| AU-5(2) |  | ? |  |  |  |  |
| AU-5(2) |  |  |  |  |  |  |
| AU-5(4) |  |  |  |  |  |  |
| AU-6 |  |  | shared |  |  |  |
| AU-6a |  |  |  |  |  |  |
| AU-6b |  |  |  |  |  |  |
| AU-6(1) |  | ? |  |  | x | x |
| AU-6(2) |  |  |  |  |  |  |
| AU-6(3) | yes |  |  | yes | x | x |
| AU-6(4) |  | ? |  |  |  |  |
| AU-6(5) | yes |  |  |  |  | x |
| AU-6(6) | yes |  |  |  |  | x |
| AU-6(7) | yes |  |  |  |  |  x|
| AU-6(8) |  |  |  |  |  |  |
| AU-6(9) |  |  |  |  |  |  |
| AU-6(10) |  | ? |  |  |  |  |
| AU-7 |  | yes |  |  | x | x |
| AU-7a |  | yes |  |  | x | x |
| AU-7b |  |  |  |  | x | x |
| AU-7 (1) |  | yes |  |  | x | x |
| AU-7 (1) |  |  |  |  |  |  |
| AU-8 |  | ? |  |  |  |  |
| AU-8a |  |  |  |  |  |  |
| AU-8b |  |  |  |  |  |  |
| AU-8(1) |  | ? |  |  |  |  |
| AU-8(1)(a) |  |  |  |  |  |  |
| AU-8(1)(b) |  |  |  |  |  |  |
| AU-8(2) |  |  |  |  |  |  |
| AU-9 |  | ? |  |  |  |  |
| AU-9(1) |  |  |  |  |  |  |
| AU-9(2) | yes |  |  | yes |  |  |
| AU-9(3) |  | ? |  |  |  |  |
| AU-9(4) |  | ? |  |  |  |  |
| AU-9(5) |  |  |  |  |  |  |
| AU-9(6) |  |  |  |  |  |  |
| AU-10 | yes |  |  |  |  |  |
| AU-10(1) |  |  |  |  |  |  |
| AU-10(1)(a) |  |  |  |  |  |  |
| AU-10(1)(b) |  |  |  |  |  |  |
| AU-10(2) |  |  |  |  |  |  |
| AU-10(2)(a) |  |  |  |  |  |  |
| AU-10(2)(b) |  |  |  |  |  |  |
| AU-10(3) |  |  |  |  |  |  |
| AU-10(4) |  |  |  |  |  |  |
| AU-10(4)(a) |  |  |  |  |  |  |
| AU-10(4)(b) |  |  |  |  |  |  |
| AU-10(5) |  |  |  |  |  |  |
| AU-11|  | ? |  | yes |  |  |
| AU-11(1) |  |  |  |  |  |  |
| AU-12 |  | yes |  |  | x | x |
| AU-12a |  | yes |  |  | x | x |
| AU-12b |  | yes |  |  | x | x |
| AU-12c |  | yes |  |  | x | x |
| AU-12(1) |  | yes |  |  |  | x |
| AU-12(2) |  |  |  |  |  |  |
| AU-12(3) |  | yes |  |  |  | x |
| AU-13 |  |  |  |  |  |  |
| AU-13(1) |  |  |  |  |  |  |
| AU-13(2) |  |  |  |  |  |  |
| AU-14 |  |  |  |  |  |  |
| AU-14(1) |  |  |  |  |  |  |
| AU-14(2) |  |  |  |  |  |  |
| AU-14(3) |  |  |  |  |  |  |
| AU-15 |  |  |  |  |  |  |
| AU-16 |  |  |  |  |  |  |
| AU-16(1) |  |  |  |  |  |  |
| AU-16(2) |  |  |  |  |  |  |
| CA-1 |  |  |  |  |  |  |
| CA-1a |  |  |  |  |  |  |
| CA-1a1 |  |  |  |  |  |  |
| CA-1b |  |  |  |  |  |  |
| CA-1b1 |  |  |  |  |  |  |
| CA-1b2 |  |  |  |  |  |  |
| CA-2 |  |  |  |  |  |  |
| CA-2a |  |  |  |  |  |  |
| CA-2a1 |  |  |  |  |  |  |
| CA-2a2 |  |  |  |  |  |  |
| CA-2a3 |  |  |  |  |  |  |
| CA-2b |  |  |  |  |  |  |
| CA-2c |  |  |  |  |  |  |
| CA-2d |  |  |  |  |  |  |
| CA-2(1) |  |  |  |  |  |  |
| CA-2(2) |  |  |  |  |  |  |
| CA-2(3) |  |  |  |  |  |  |
| CA-3 |  |  |  |  |  |  |
| CA-3a |  |  |  |  |  |  |
| CA-3b |  |  |  |  |  |  |
| CA-3c |  |  |  |  |  |  |
| CA-3(1) |  |  |  |  |  |  |
| CA-3(2) |  |  |  |  |  |  |
| CA-3(3) |  |  |  |  |  |  |
| CA-3(4) |  |  |  |  |  |  |
| CA-3(5) |  |  |  |  |  |  |
| CA-4 |  |  |  |  |  |  |
| CA-5 |  |  |  |  |  |  |
| CA-5a |  |  |  |  |  |  |
| CA-5b |  |  |  |  |  |  |
| CA-5(1) |  |  |  |  |  |  |
| CA-6 |  |  |  |  |  |  |
| CA-6a |  |  |  |  |  |  |
| CA-6b |  |  |  |  |  |  |
| CA-6c |  |  |  |  |  |  |
| CA-7 |  |  |  |  |  |  |
| CA-7a |  |  |  |  |  |  |
| CA-7b |  |  |  |  |  |  |
| CA-7c |  |  |  |  |  |  |
| CA-7d |  |  |  |  |  |  |
| CA-7e |  |  |  |  |  |  |
| CA-7f |  |  |  |  |  |  |
| CA-7g |  |  |  |  |  |  |
| CA-7(1) |  |  |  |  |  |  |
| CA-7(2) |  |  |  |  |  |  |
| CA-7(3) |  |  |  |  |  |  |
| CA-8 |  |  |  |  |  |  |
| CA-8(1) |  |  |  |  |  |  |
| CA-8(2) |  |  |  |  |  |  |
| CA-9 |  |  |  |  |  |  |
| CA-9a |  |  |  |  |  |  |
| CA-9b |  |  |  |  |  |  |
| CA-9(1) |  |  |  |  |  |  |
| CM-1 | yes |  |  | yes |  |  |
| CM-1a |  |  |  |  |  |  |
| CM-1a1 |  |  |  |  |  |  |
| CM-1a2 |  |  |  |  |  |  |
| CM-1b |  |  |  |  |  |  |
| CM-1b1 |  |  |  |  |  |  |
| CM-1b2 |  |  |  |  |  |  |
| CM-2 |  | yes |  |  |  |  |
| CM-2(1) |  | yes |  |  |  |  |
| CM-2(1)(a) |  |  |  |  |  |  |
| CM-2(1)(b) |  |  |  |  |  |  |
| CM-2(1)(c) |  |  |  |  |  |  |
| CM-2(2) |  | yes |  |  |  |  |
| CM-2(3) |  | yes |  |  |  |  |
| CM-2(3) |  |  |  |  |  |  |
| CM-2(4) |  |  |  |  |  |  |
| CM-2(5) |  |  |  |  |  |  |
| CM-2(6) |  |  |  |  |  |  |
| CM-2(7) | n/a? |  |  |  |  |  |
| CM-2(7)(a) |  |  |  |  |  |  |
| CM-2(7)(b) |  |  |  |  |  |  |
| CM-3 |  |  |  |  |  |  |
| CM-3a |  |  |  |  |  |  |
| CM-3b |  |  |  |  |  |  |
| CM-3c |  |  |  |  |  |  |
| CM-3d |  |  |  |  |  |  |
| CM-3e |  |  |  |  |  |  |
| CM-3f |  |  |  |  |  |  |
| CM-3g |  |  |  |  |  |  |
| CM-3(1) |  |  | shared |  |  |  |
| CM-3(1)(a) |  |  |  |  |  |  |
| CM-3(1)(b) |  |  |  |  |  |  |
| CM-3(1)(c) |  |  |  |  |  |  |
| CM-3(1)(d) |  |  |  |  |  |  |
| CM-3(1)(e) |  |  |  |  |  |  |
| CM-3(1)(f) |  |  |  |  |  |  |
| CM-3(2) |  |  | Shared |  |  |  |
| CM-3(3) |  |  |  |  |  |  |
| CM-3(4) | yes |  |  |  |  |  |
| CM-3(5) |  |  | shared? | yes? |  |  |
| CM-3(6) |  |  |  |  |  |  |
| CM-4 | yes |  |  |  |  |  |
| CM-4(1) | yes |  |  |  |  |  |
| CM-4(2) |  |  |  |  |  |  |
| CM-5 |  |  | shared |  |  |  |
| CM-5(1) |  | roadmap? |  |  |  |  |
| CM-5(2) |  |  | Shared |  |  |  |
| CM-5(3) |  | ? |  |  |  |  |
| CM-5(4) |  |  |  |  |  |  |
| CM-5(5) |  | ? |  |  |  |  |
| CM-5(5)(a) |  |  |  |  |  |  |
| CM-5(5)(b) |  |  |  |  |  |  |
| CM-5(6) |  |  |  |  |  |  |
| CM-5(7) |  |  |  |  |  |  |
| CM-6 |  |  | yes |  | x | x |
| CM-6a |  |  |  |  |  |  |
| CM-6b   |  |  |  |  |  |
| CM-6c |  |  |  |  |  |  |
| CM-6d |  |  |  |  |  |  |
| CM-6(1) |  |  | yes |  |  | x |
| CM-6(2) |  |  | shared |  |  |  |
| CM-6(3) |  |  |  |  |  |  |
| CM-6(4) |  |  |  |  |  |  |
| CM-7 |  | yes |  |  | x | x |
| CM-7a |  |  |  |  |  |  |
| CM-7b |  |  |  |  |  |  |
| CM-7(1) |  |  |  |  |  |  |
| CM-7(1)(a) |  |  |  |  |  |  |
| CM-7(1)(b) |  |  |  |  |  |  |
| CM-7(2) |  |  | yes |  | x | x |
| CM-7(3) |  |  |  |  |  |  |
| CM-7(4) | yes |  |  | yes | x |  |
| CM-7(4)(a) | yes |  |  |  |  |  |
| CM-7(4)(b) | yes |  |  | yes | x |  |
| CM-7(4)(c) |  |  |  |  |  |  |
| CM-7(5) | yes |  |  |  |  |  |
| CM-7(5)(a) |  |  |  |  |  |  |
| CM-7(5)(b) | yes |  |  | yes |  | x |
| CM-7(5)(c) |  |  |  |  |  |  |
| CM-8 |  | yes | ? |  |  |  |
| CM-8a |  |  |  |  |  |  |
| CM-8a1 |  |  |  |  |  |  |
| CM-8a2 |  |  |  |  |  |  |
| CM-8a3 |  |  |  |  |  |  |
| CM-8a4 |  |  |  |  |  |  |
| CM-8b |  |  |  |  |  |  |
| CM-8(1) |  | yes |  |  |  |  |
| CM-8(2) |  | yes |  |  |  |  |
| CM-8(3) |  | yes |  |  |  |  |
| CM-8(3)(a) |  |  |  |  |  |  |
| CM-8(3)(b) |  |  |  |  |  |  |
| CM-8(4) |  |  | ?? |  |  |  |
| CM-8(5) |  | ?? |  |  |  |  |
| CM-8(6) |  |  |  |  |  |  |
| CM-8(7) |  |  |  |  |  |  |
| CM-8(8) |  |  |  |  |  |  |
| CM-8(9) |  |  |  |  |  |  |
| CM-8(9)(a) |  |  |  |  |  |  |
| CM-8(9)(b) |  |  |  |  |  |  |
| CM-9 | yes |  |  |  |  |  |
| CM-9a |  |  |  |  |  |  |
| CM-9b |  |  |  |  |  |  |
| CM-9c |  |  |  |  |  |  |
| CM-9d |  |  |  |  |  |  |
| CM-9(1) |  |  |  |  |  |  |
| CM-10 | yes |  |  |  |  |  |
| CM-10a |  |  |  |  |  |  |
| CM-10b |  |  |  |  |  |  |
| CM-10c |  |  |  |  |  |  |
| CM-10(1) |  |  |  |  |  |  |
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
| CP-10 (5) |  |  |  |  |  |
| CP-10 (6) |  |  |  |  |  |
| CP-11 |  |  |  |  |  |
| CP-12 |  |  |  |  |  |
| CP-13 |  |  |  |  |  |
| IA-1 | yes |  |  |  | x | x |
| IA-1a |  |  |  |  |  |
| IA-1a1 |  |  |  |  |  |
| IA-1a2 |  |  |  |  |  |
| IA-1b |  |  |  |  |  |
| IA-1b1 |  |  |  |  |  |
| IA-1b2 |  |  |  |  |  |
| IA-2 |  | yes |  | yes | x | x |
| IA-2(1) |  |  |  |  |  |
| IA-2(2) |  |  | yes |  | x | x |
| IA-2(3) | yes |  |  | yes |  |  |
| IA-2(4) |  | yes |  | yes |  | x |
| IA-2(5) |  |  |  |  |  |
| IA-2(6) |  |  |  |  |  |
| IA-2(7) |  |  |  |  |  |
| IA-2(8) |  |  |  |  |  |
| IA-2(9) |  | yes |  | yes |  | x |
| IA-2(10) |  |  |  |  |  |
| IA-2(11) |  | yes |  | yes | x | x |
| IA-2(12) |  | yes |  | yes | x | x |
| IA-2(13) |  |  |  |  |  |
| IA-3 |  |  | yes | yes | x | x |
| IA-3(1) |  |  |  |  |  |  |
| IA-3(2) |  |  |  |  |  |  |
| IA-3(3) |  |  |  |  |  |  |
| IA-3(3)(a) |  |  |  |  |  |  |
| IA-3(3)(b) |  |  |  |  |  |  |
| IA-3(4) |  |  |  |  |  |  |
| IA-4 |  | yes |  | yes | x | x |
| IA-4a |  | yes |  | yes | x | x |
| IA-4b |  | yes |  | yes | x | x |
| IA-4c |  | yes |  | yes | x | x |
| IA-4d |  | yes |  | yes | x | x |
| IA-4e |  |  |  |  |  |  |
| IA-4(1) |  |  |  |  |  |  |
| IA-4(2) |  |  |  |  |  |  |
| IA-4(3) |  |  |  |  |  |  |
| IA-4(4) |  |  |  |  |  |  |
| IA-4(5) |  |  |  |  |  |  |
| IA-4(6) |  |  |  |  |  |  |
| IA-4(7) |  |  |  |  |  |  |
| IA-5 | yes |  |  | yes | x | x |
| IA-5a |  |  |  |  |  |  |
| IA-5b |  |  |  |  |  |  |
| IA-5c |  |  |  |  |  |  |
| IA-5d |  |  |  |  |  |  |
| IA-5e |  |  |  |  |  |  |
| IA-5f |  |  |  |  |  |  |
| IA-5g |  |  |  |  |  |  |
| IA-5h |  |  |  |  |  |  |
| IA-5i |  |  |  |  |  |  |
| IA-5j |  |  |  |  |  |  |
| IA-5(1) | yes |  |  | yes | x | x |
| IA-5(1)(a) | yes |  |  | yes | x | x |
| IA-5(1)(d) | yes |  |  | yes | x | x |
| IA-5(1)(e) | yes |  |  | yes | x | x |
| IA-5(1)(f) | yes |  |  | yes | x | x |
| IA-5(2) |  |  |  |  |  |  |
| IA-5(2)(a) |  |  |  |  |  |  |
| IA-5(2)(b) |  |  |  |  |  |  |
| IA-5(2)(c) |  |  |  |  |  |  |
| IA-5(2)(d) |  |  |  |  |  |  |
| IA-5(3) |  |  |  |  |  |  |
| IA-5(4) |  |  |  |  |  |  |
| IA-5(5) |  |  |  |  |  |  |
| IA-5(6) |  | ?? |  |  |  |  |
| IA-5(7) |  | ?? |  |  |  |  |
| IA-5(8) |  |  |  |  |  |  |
| IA-5(9) |  |  |  |  |  |  |
| IA-5(10) |  |  |  |  |  |  |
| IA-5 (11) |  |  |  | yes | x | x |
| IA-5(12) |  |  |  |  |  |  |
| IA-5(13) |  |  |  |  |  |  |
| IA-5(14) |  |  |  |  |  |  |
| IA-5(15) |  |  |  |  |  |  |
| IA-6 | yes |  |  | yes | x | x |
| IA-7 | yes |  |  | yes | x | x |
| IA-8 |  |  | yes |  | x | x |
| IA-8(1) | |  |  |  |  |  |
| IA-8(2) | |  |  |  |  |  |
| IA-8(3) | yes |  |  | yes | x | x |
| IA-8(4) |  |  |  |  |  |  |
| IA-8(5) |  |  |  |  |  |  |
| IA-9 |  |  |  |  |  |  |
| IA-9(1) |  |  |  |  |  |  |
| IA-9(2) |  |  |  |  |  |  |
| IA-10 |  |  |  |  |  |  |
| IA-11 |  |  |  |  |  |  |
| IR-1 | yes |  |  | yes | x | x |
| IR-1a |  |  |  |  |  |  |
| IR-1a1 |  |  |  |  |  |  |
| IR-1a2 |  |  |  |  |  |  |
| IR-1b |  |  |  |  |  |  |
| IR-1b1 |  |  |  |  |  |  |
| IR-1b2 |  |  |  |  |  |  |
| IR-2 | yes |  |  | yes | x | x |
| IR-2a |  |  |  |  |  |  |
| IR-2b |  |  |  |  |  |  |
| IR-2c |  |  |  |  |  |  |
| IR-2 (1) | yes |  |  | yes |  | x |
| IR-2 (2) | yes |  |  | yes |  | x |
| IR-3 | yes |  |  | yes | x | x |
| IR-3 (1) | yes |  |  | yes | x | x |
| IR-3 (2) | yes |  |  | yes | x | x |
| IR-4 | yes |  |  | yes | x | x |
| IR-4a |  |  |  |  |  |  |
| IR-4b |  |  |  |  |  |  |
| IR-4c |  |  |  |  |  |  |
| IR-4(1) | yes |  |  | yes | x | x |
| IR-4(2) | yes |  |  | yes | x |  |
| IR-4(3) |  |  |  | yes |  | x |
| IR-4(4) | yes |  |  | yes |  | x |
| IR-4(5) |  |  |  |  |  |  |
| IR-4(6) |  |  |  |  |  |  |
| IR-4(7) |  |  |  |  |  |  |
| IR-4(8) |  |  |  |  |  |  |
| IR-4(9) |  |  |  |  |  |  |
| IR-4(10) |  |  |  |  |  |  |
| IR-5 |  |  | yes |  | x | x |
| IR-5 (1) |  |  | yes |  |  | x |
| IR-6 | yes |  |  | yes | x | x |
| IR-6a |  |  |  |  |  |  |
| IR-6b |  |  |  |  |  |  |
| IR-6 (1) | yes |  |  | yes | x | x |
| IR-6 (2) |  |  |  |  |  |  |
| IR-6 (3) |  |  |  |  |  |  |
| IR-7 | yes |  |  | yes | x | x |
| IR-7 (1) | yes |  |  | yes | x | x |
| IR-7 (2) |  |  |  |  |  |  |
| IR-7 (2)(a) |  |  |  |  |  |  |
| IR-7 (2)(b) |  |  |  |  |  |  |
| IR-8 | yes |  |  | yes | x | x |
| IR-8a |  |  |  |  |  |  |
| IR-8a1 |  |  |  |  |  |  |
| IR-8a2 |  |  |  |  |  |  |
| IR-8a3 |  |  |  |  |  |  |
| IR-8a4 |  |  |  |  |  |  |
| IR-8a5 |  |  |  |  |  |  |
| IR-8a6 |  |  |  |  |  |  |
| IR-8a7 |  |  |  |  |  |  |
| IR-8a8 |  |  |  |  |  |  |
| IR-8b |  |  |  |  |  |  |
| IR-8c |  |  |  |  |  |  |
| IR-8d |  |  |  |  |  |  |
| IR-8e |  |  |  |  |  |  |
| IR-8f |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-9 |  |  |  |  |  |  |
| IR-10 |  |  |  |  |  |  |
| MA-1 | yes |  |  | yes | x | x |
| MA-1a |  |  |  |  |  |  |
| MA-1a1 |  |  |  |  |  |  |
| MA-1a2 |  |  |  |  |  |  |
| MA-1b |  |  |  |  |  |  |
| MA-1b1 |  |  |  |  |  |  |
| MA-1b2 |  |  |  |  |  |  |
| MA-2 | yes |  |  | yes | x | x |
| MA-2 (1) |  |  |  |  |  |  |
| MA-2 (2) |  |  |  |  |  |  |
| MA-3 | yes |  |  | yes | x | x |
| MA-3(1) | yes |  |  | yes | x | x |
| MA-3(2) | yes |  |  | yes | x | x |
| MA-3(3) | yes |  |  | yes | x | x |
| MA-3(3)(a) |  |  |  |  |  |  |
| MA-3(3)(b) |  |  |  |  |  |  |
| MA-3(3)(c) |  |  |  |  |  |  |
| MA-3(3)(d) |  |  |  |  |  |  |
| MA-3(4) |  |  |  |  |  |  |
| MA-4 | yes |  |  | yes | x | x |
| MA-4a |  |  |  |  |  |  |
| MA-4b |  |  |  |  |  |  |
| MA-4c |  |  |  |  |  |  |
| MA-4d |  |  |  |  |  |  |
| MA-4e |  |  |  |  |  |  |
| MA-4(1) |  |  |  |  |  |  |
| MA-4(1)(a) |  |  |  |  |  |  |
| MA-4(1)(b) |  |  |  |  |  |  |
| MA-4(2) |yes |  |  | yes | x | x |
| MA-4(3) |yes |  |  | yes | x | x |
| MA-4(3)(a) |  |  |  |  |  |  |
| MA-4(3)(b) |  |  |  |  |  |  |
| MA-4(4) |  |  |  |  |  |  |
| MA-4(4)(a) |  |  |  |  |  |  |
| MA-4(4)(b) |  |  |  |  |  |  |
| MA-4(4)(b)(1) |  |  |  |  |  |  |
| MA-4(4)(b)(2) |  |  |  |  |  |  |
| MA-4(5) |  |  |  |  |  |  |
| MA-4(5)(a) |  |  |  |  |  |  |
| MA-4(5)(b) |  |  |  |  |  |  |
| MA-4(6) |  |  |  |  |  |  |
| MA-4(7) |  |  |  |  |  |  |
| MA-5 |yes |  |  | yes | x | x |
| MA-5a |  |  |  |  |  |  |
| MA-5b |  |  |  |  |  |  |
| MA-5c |  |  |  |  |  |  |
| MA-5(1) |yes |  |  | yes | x | x |
| MA-5(1)(a) |  |  |  |  |  |  |
| MA-5(1)(a)(1) |  |  |  |  |  |  |
| MA-5(1)(a)(2) |  |  |  |  |  |  |
| MA-5(1)(b) |  |  |  |  |  |  |
| MA-5(2) |  |  |  |  |  |  |
| MA-5(3) |  |  |  |  |  |  |
| MA-5(4) |  |  |  |  |  |  |
| MA-5(4)(a) |  |  |  |  |  |  |
| MA-5(4)(b) |  |  |  |  |  |  |
| MA-5(5) |  |  |  |  |  |  |
| MA-6 |yes |  |  | yes | x | x |
| MA-6(1) |  |  |  |  |  |  |
| MA-6(2) |  |  |  |  |  |  |
| MA-6(3) |  |  |  |  |  |  |
| MP-1 |yes |  |  | yes | x | x |
| MP-1a |  |  |  |  |  |  |
| MP-1a1 |  |  |  |  |  |  |
| MP-1a2 |  |  |  |  |  |  |
| MP-1b |  |  |  |  |  |  |
| MP-1b1 |  |  |  |  |  |  |
| MP-1b2 |  |  |  |  |  |  |
| MP-2 |yes |  |  | yes | x | x |
| MP-2(1) |  |  |  |  |  |  |
| MP-2(2) |  |  |  |  |  |  |
| MP-3 |yes |  |  | yes | x | x |
| MP-3a |  |  |  |  |  |  |
| MP-3b |  |  |  |  |  |  |
| MP-4 |yes |  |  | yes | x | x |
| MP-4a |  |  |  |  |  |  |
| MP-4b |  |  |  |  |  |  |
| MP-4(1) |  |  |  |  |  |  |
| MP-4(2) |  |  |  |  |  |  |
| MP-5 |yes |  |  | yes | x | x |
| MP-5a |  |  |  |  |  |  |
| MP-5b |  |  |  |  |  |  |
| MP-5c |  |  |  |  |  |  |
| MP-5d |  |  |  |  |  |  |
| MP-5(1) |  |  |  |  |  |  |
| MP-5(2) |  |  |  |  |  |  |
| MP-5(3) |  |  |  |  |  |  |
| MP-5 (4) |yes |  |  | yes | x | x |
| MP-6 |yes |  |  | yes | x | x |
| MP-6a |  |  |  |  |  |  |
| MP-6b |  |  |  |  |  |  |
| MP-6c |  |  |  |  |  |  |
| MP-6d |  |  |  |  |  |  |
| MP-6(1) | yes |  |  | yes |  | x |
| MP-6(2) | yes |  |  | yes |  | x |
| MP-6(3) | yes |  |  | yes |  | x |
| MP-6(4) |  |  |  |  |  |  |
| MP-6(5) |  |  |  |  |  |  |
| MP-6(6) |  |  |  |  |  |  |
| MP-6(7) |  |  |  |  |  |  |
| MP-6(8) |  |  |  |  |  |  |
| MP-7 |yes |  |  | yes | x | x |
| MP-7(1) |yes |  |  | yes | x | x |
| MP-7(2) |  |  |  |  |  |  |
| MP-8 |  |  |  |  |  |  |
| MP-8a |  |  |  |  |  |  |
| MP-8b |  |  |  |  |  |  |
| MP-8c |  |  |  |  |  |  |
| MP-8d |  |  |  |  |  |  |
| MP-8(1) |  |  |  |  |  |  |
| MP-8(2) |  |  |  |  |  |  |
| MP-8(3) |  |  |  |  |  |  |
| MP-8(4) |  |  |  |  |  |  |
| PE-1 |yes |  |  | yes | x | x |
| PE-1a |  |  |  |  |  |  |
| PE-1a1 |  |  |  |  |  |  |
| PE-1a2 |  |  |  |  |  |  |
| PE-1b |  |  |  |  |  |  |
| PE-1b1 |  |  |  |  |  |  |
| PE-1b2 |  |  |  |  |  |  |
| PE-2 |yes |  |  | yes | x | x |
| PE-2a |  |  |  |  |  |  |
| PE-2b |  |  |  |  |  |  |
| PE-2c |  |  |  |  |  |  |
| PE-2d |  |  |  |  |  |  |
| PE-2(1) |  |  |  |  |  |  |
| PE-2(2) |  |  |  |  |  |  |
| PE-2(3) |  |  |  |  |  |  |
| PE-3 |yes |  |  | yes | x | x |
| PE-3a |  |  |  |  |  |  |
| PE-3a1 |  |  |  |  |  |  |
| PE-3a2 |  |  |  |  |  |  |
| PE-3b |  |  |  |  |  |  |
| PE-3c |  |  |  |  |  |  |
| PE-3d |  |  |  |  |  |  |
| PE-3e |  |  |  |  |  |  |
| PE-3f |  |  |  |  |  |  |
| PE-3g |  |  |  |  |  |  |
| PE-3(1) | yes |  |  | yes |  | x |
| PE-3(2) |  |  |  |  |  |  |
| PE-3(3) |  |  |  |  |  |  |
| PE-3(4) |  |  |  |  |  |  |
| PE-3(5) |  |  |  |  |  |  |
| PE-3(6) |  |  |  |  |  |  |
| PE-4 |yes |  |  | yes | x | x |
| PE-5 |yes |  |  | yes | x | x |
| PE-5(1) |  |  |  |  |  |  |
| PE-5(1)(a) |  |  |  |  |  |  |
| PE-5(1)(b) |  |  |  |  |  |  |
| PE-5(2) |  |  |  |  |  |  |
| PE-5(2)(a) |  |  |  |  |  |  |
| PE-5(2)(b) |  |  |  |  |  |  |
| PE-5(3) |  |  |  |  |  |  |
| PE-6 |yes |  |  | yes | x | x |
| PE-6a |  |  |  |  |  |  |
| PE-6b |  |  |  |  |  |  |
| PE-6c |  |  |  |  |  |  |
| PE-6(1) |yes |  |  | yes | x | x |
| PE-6(2) |  |  |  |  |  |  |
| PE-6(3) |  |  |  |  |  |  |
| PE-6(4) | yes |  |  | yes |  | x |
| PE-7 |  |  |  |  |  |  |
| PE-8 |yes |  |  | yes | x | x |
| PE-8 |  |  |  |  |  |  |
| PE-8 |  |  |  |  |  |  |
| PE-8(1) | yes |  |  | yes |  | x |
| PE-8(1) |  |  |  |  |  |  |
| PE-9 |yes |  |  | yes | x | x |
| PE-9(1) |  |  |  |  |  |  |
| PE-9(2) |  |  |  |  |  |  |
| PE-10 |yes |  |  | yes | x | x |
| PE-10a |  |  |  |  |  |  |
| PE-10b |  |  |  |  |  |  |
| PE-10c |  |  |  |  |  |  |
| PE-10(1) |  |  |  |  |  |  |
| PE-11 |yes |  |  | yes | x | x |
| PE-11(1) |  |  |  |  |  |  |
| PE-11(2) |  |  |  |  |  |  |
| PE-11(2)(a) |  |  |  |  |  |  |
| PE-11(2)(b) |  |  |  |  |  |  |
| PE-11(2)(c) |  |  |  |  |  |  |
| PE-12 |yes |  |  | yes | x | x |
| PE-12(1) |  |  |  |  |  |  |
| PE-13 |yes |  |  | yes | x | x |
| PE-13(1) | yes |  |  | yes |  | x |
| PE-13(2) | yes |  |  | yes |  | x |
| PE-13(3) | yes |  |  | yes | x | x |
| PE-13(4) |  |  |  |  |  |  |
| PE-14 |yes |  |  | yes | x | x |
| PE-14a |  |  |  |  |  |  |
| PE-14b |  |  |  |  |  |  |
| PE-14(1) |  |  |  |  |  |  |
| PE-14(2) |  |  |  |  |  |  |
| PE-15 |yes |  |  | yes | x | x |
| PE-15(1) | yes |  |  | yes |  | x |
| PE-16 |yes |  |  | yes | x | x |
| PE-17 |yes |  |  | yes | x | x |
| PE-17a |  |  |  |  |  |  |
| PE-17b |  |  |  |  |  |  |
| PE-17c |  |  |  |  |  |  |
| PE-18 | yes |  |  | yes |  | x |
| PE-18(1) |  |  |  |  |  |  |
| PE-19 |  |  |  |  |  |  |
| PE-19(1) |  |  |  |  |  |  |
| PE-20 |  |  |  |  |  |  |
| PE-20a |  |  |  |  |  |  |
| PE-20b |  |  |  |  |  |  |
| PL-1 |yes |  |  | yes | x | x |
| PL-1a |  |  |  |  |  |  |
| PL-1a1 |  |  |  |  |  |  |
| PL-1a2 |  |  |  |  |  |  |
| PL-1b |  |  |  |  |  |  |
| PL-1b1 |  |  |  |  |  |  |
| PL-1b2 |  |  |  |  |  |  |
| PL-2 |yes |  |  | yes | x | x |
| PL-2a |  |  |  |  |  |  |
| PL-2a1 |  |  |  |  |  |  |
| PL-2a2 |  |  |  |  |  |  |
| PL-2a3 |  |  |  |  |  |  |
| PL-2a4 |  |  |  |  |  |  |
| PL-2a5 |  |  |  |  |  |  |
| PL-2a6 |  |  |  |  |  |  |
| PL-2a7 |  |  |  |  |  |  |
| PL-2a8 |  |  |  |  |  |  |
| PL-2a9 |  |  |  |  |  |  |
| PL-2b |  |  |  |  |  |  |
| PL-2c |  |  |  |  |  |  |
| PL-2d |  |  |  |  |  |  |
| PL-2e |  |  |  |  |  |  |
| PL-2(1) |  |  |  |  |  |  |
| PL-2(2) |  |  |  |  |  |  |
| PL-2(3) |yes |  |  | yes | x | x |
| PL-3 |  |  |  |  |  |  |
| PL-4 |yes |  |  | yes | x | x |
| PL-4a |  |  |  |  |  |  |
| PL-4b |  |  |  |  |  |  |
| PL-4c |  |  |  |  |  |  |
| PL-4d |  |  |  |  |  |  |
| PL-4 (1) |yes |  |  | yes | x | x |
| PL-5 |  |  |  |  |  |  |
| PL-6 |  |  |  |  |  |  |
| PL-7 |  |  |  |  |  |  |
| PL-7a |  |  |  |  |  |  |
| PL-7b |  |  |  |  |  |  |
| PL-8 |  |  | yes |  | x | x |
| PL-8a |  |  |  |  |  |  |
| PL-8a1 |  |  |  |  |  |  |
| PL-8a2 |  |  |  |  |  |  |
| PL-8b |  |  |  |  |  |  |
| PL-8c |  |  |  |  |  |  |
| PL-8(1) |  |  |  |  |  |  |
| PL-8(1)(a) |  |  |  |  |  |  |
| PL-8(1)(b) |  |  |  |  |  |  |
| PL-8(2) |  |  |  |  |  |  |
| PL-9 |  |  |  |  |  |  |
| PS-1 |yes |  |  | yes | x | x |
| PS-1a |  |  |  |  |  |  |
| PS-1a1 |  |  |  |  |  |  |
| PS-1a2 |  |  |  |  |  |  |
| PS-1b |  |  |  |  |  |  |
| PS-1b1 |  |  |  |  |  |  |
| PS-1b2 |  |  |  |  |  |  |
| PS-2 |yes |  |  | yes | x | x |
| PS-2a |  |  |  |  |  |  |
| PS-2b |  |  |  |  |  |  |
| PS-2c |  |  |  |  |  |  |
| PS-3 | yes |  |  | yes | x | x |
| PS-3a |  |  |  |  |  |  |
| PS-3b |  |  |  |  |  |  |
| PS-3(1) |  |  |  |  |  |  |
| PS-3(2) |  |  |  |  |  |  |
| PS-3(3) |  |  |  |  |  |  |
| PS-3(3)(a) |  |  |  |  |  |  |
| PS-3(3)(b) |  |  |  |  |  |  |
| PS-4 | yes |  |  | yes | x | x |
| PS-4a |  |  |  |  |  |  |
| PS-4b |  |  |  |  |  |  |
| PS-4c |  |  |  |  |  |  |
| PS-4d |  |  |  |  |  |  |
| PS-4e |  |  |  |  |  |  |
| PS-4f |  |  |  |  |  |  |
| PS-4(1) |  |  |  |  |  |  |
| PS-4(1)(a) |  |  |  |  |  |  |
| PS-4(1)(b) |  |  |  |  |  |  |
| PS-4(2) | yes |  |  | yes |  | x |
| PS-5 | yes |  |  | yes | x | x |
| PS-5a |  |  |  |  |  |  |
| PS-5b |  |  |  |  |  |  |
| PS-5c |  |  |  |  |  |  |
| PS-5d |  |  |  |  |  |  |
| PS-6 | yes |  |  | yes | x | x |
| PS-6a |  |  |  |  |  |  |
| PS-6b |  |  |  |  |  |  |
| PS-6c |  |  |  |  |  |  |
| PS-6c1 |  |  |  |  |  |  |
| PS-6c2 |  |  |  |  |  |  |
| PS-6(1) |  |  |  |  |  |  |
| PS-6(2) |  |  |  |  |  |  |
| PS-6(2)(a) |  |  |  |  |  |  |
| PS-6(2)(b) |  |  |  |  |  |  |
| PS-6(2)(c) |  |  |  |  |  |  |
| PS-6(3) |  |  |  |  |  |  |
| PS-6(3)(a) |  |  |  |  |  |  |
| PS-6(3)(b) |  |  |  |  |  |  |
| PS-6(1) |  |  |  |  |  |  |
| PS-6(2) |  |  |  |  |  |  |
| PS-6(3) |  |  |  |  |  |  |
| PS-6(3)(a) |  |  |  |  |  |  |
| PS-6(3)(b) |  |  |  |  |  |  |
| PS-7 | yes |  |  | yes | x | x |
| PS-7a |  |  |  |  |  |  |
| PS-7b |  |  |  |  |  |  |
| PS-7c |  |  |  |  |  |  |
| PS-7d |  |  |  |  |  |  |
| PS-7e |  |  |  |  |  |  |
| PS-8 | yes |  |  | yes | x | x |
| PS-8a |  |  |  |  |  |  |
| PS-8b |  |  |  |  |  |  |
| RA-1 | yes |  |  | yes | x | x |
| RA-1a |  |  |  |  |  |  |
| RA-1a1 |  |  |  |  |  |  |
| RA-1a2 |  |  |  |  |  |  |
| RA-1b |  |  |  |  |  |  |
| RA-1b1 |  |  |  |  |  |  |
| RA-1b2 |  |  |  |  |  |  |
| RA-2 | yes |  |  | yes | x | x |
| RA-2a |  |  |  |  |  |  |
| RA-2b |  |  |  |  |  |  |
| RA-2c |  |  |  |  |  |  |
| RA-3 | yes |  |  | yes | x | x |
| RA-3a |  |  |  |  |  |  |
| RA-3b |  |  |  |  |  |  |
| RA-3c |  |  |  |  |  |  |
| RA-3d |  |  |  |  |  |  |
| RA-3e |  |  |  |  |  |  |
| RA-4 |  |  |  |  |  |  |
| RA-5 |  |  | yes |  | x | x |
| RA-5a |  |  |  |  |  |  |
| RA-5b |  |  |  |  |  |  |
| RA-5b1 |  |  |  |  |  |  |
| RA-5b2 |  |  |  |  |  |  |
| RA-5b3 |  |  |  |  |  |  |
| RA-5c |  |  |  |  |  |  |
| RA-5d |  |  |  |  |  |  |
| RA-5e |  |  |  |  |  |  |
| RA-5(1) |  |  | yes |  | x | x |
| RA-5(2) |  |  | yes |  | x | x |
| RA-5(4) |  |  | yes |  |  | x |
| RA-5(5) |  |  | yes |  | x | x |
| RA-5(6) |  |  |  |  |  |  |
| RA-5(7) |  |  |  |  |  |  |
| RA-5(8) |  |  |  |  |  |  |
| RA-5(9) |  |  |  |  |  |  |
| RA-5(10) |  |  |  |  |  |  |
| RA-6 |  |  |  |  |  |  |
| RA-7 |  |  | yes |  | x | x |
| RA-9 |yes |  |  | yes | x | x |
| SA-1 |yes |  |  | yes | x | x |
| SA-1a. |  |  |  |  |  |  |
| SA-1a.1. |  |  |  |  |  |  |
| SA-1a.2. |  |  |  |  |  |  |
| SA-1b. |  |  |  |  |  |  |
| SA-1b.1. |  |  |  |  |  |  |
| SA-1b.2. |  |  |  |  |  |  |
| SA-2 |yes |  |  | yes | x | x |
| SA-2a. |  |  |  |  |  |  |
| SA-2b. |  |  |  |  |  |  |
| SA-2c. |  |  |  |  |  |  |
| SA-3 |yes |  |  | yes | x | x |
| SA-3a. |  |  |  |  |  |  |
| SA-3b. |  |  |  |  |  |  |
| SA-3c. |  |  |  |  |  |  |
| SA-3d. |  |  |  |  |  |  |
| SA-4 |yes |  |  | yes | x | x |
| SA-4a. |  |  |  |  |  |  |
| SA-4b. |  |  |  |  |  |  |
| SA-4c. |  |  |  |  |  |  |
| SA-4d. |  |  |  |  |  |  |
| SA-4e. |  |  |  |  |  |  |
| SA-4f. |  |  |  |  |  |  |
| SA-4g. |  |  |  |  |  |  |
| SA-4(1) |yes |  |  | yes | x | x |
| SA-4(2) |yes |  |  | yes | x | x |
| SA-4(3) |  |  |  |  |  |  |
| SA-4(4) |  |  |  |  |  |  |
| SA-4(5) |  |  |  |  |  |  |
| SA-4(5)(a) |  |  |  |  |  |  |
| SA-4(5)(b) |  |  |  |  |  |  |
| SA-4(6) |  |  |  |  |  |  |
| SA-4(6)(a) |  |  |  |  |  |  |
| SA-4(6)(b) |  |  |  |  |  |  |
| SA-4(7) |  |  |  |  |  |  |
| SA-4(7)(a) |  |  |  |  |  |  |
| SA-4(7)(b) |  |  |  |  |  |  |
| SA-4(8) |  |  |  |  |  |  |
| SA-4 (9)  |yes |  |  | yes | x | x |
| SA-4 (10) |yes |  |  | yes | x | x |
| SA-5 |yes |  |  | yes | x | x |
| SA-5a. |  |  |  |  |  |  |
| SA-5a.1. |  |  |  |  |  |  |
| SA-5a.2. |  |  |  |  |  |  |
| SA-5a.3. |  |  |  |  |  |  |
| SA-5b. |  |  |  |  |  |  |
| SA-5b.1. |  |  |  |  |  |  |
| SA-5b.2. |  |  |  |  |  |  |
| SA-5b.3. |  |  |  |  |  |  |
| SA-5c. |  |  |  |  |  |  |
| SA-5d. |  |  |  |  |  |  |
| SA-5e. |  |  |  |  |  |  |
| SA-5(1) |  |  |  |  |  |  |
| SA-5(2) |  |  |  |  |  |  |
| SA-5(3) |  |  |  |  |  |  |
| SA-5 4) |  |  |  |  |  |  |
| SA-5(5) |  |  |  |  |  |  |
| SA-6 |  |  |  |  |  |  |
| SA-7 |  |  |  |  |  |  |
| SA-8 |yes |  |  | yes | x | x |
| SA-9 |yes |  |  | yes | x | x |
| SA-9a. |  |  |  |  |  |  |
| SA-9b. |  |  |  |  |  |  |
| SA-9c. |  |  |  |  |  |  |
| SA-9 (1) |  |  |  |  |  |  |
| SA-9 (1)(a) |  |  |  |  |  |  |
| SA-9 (1)(b) |  |  |  |  |  |  |
| SA-9(2) |yes |  |  | yes | x | x |
| SA-9(3) |  |  |  |  |  |  |
| SA-9(4) |  |  |  |  |  |  |
| SA-9(5) |  |  |  |  |  |  |
| SA-10 |yes |  |  | yes | x | x |
| SA-10a. |  |  |  |  |  |  |
| SA-10b. |  |  |  |  |  |  |
| SA-10c. |  |  |  |  |  |  |
| SA-10d. |  |  |  |  |  |  |
| SA-10e. |  |  |  |  |  |  |
| SA-10 (1) |  |  |  |  |  |  |
| SA-10 (2) |  |  |  |  |  |  |
| SA-10 (3) |  |  |  |  |  |  |
| SA-10 (4) |  |  |  |  |  |  |
| SA-10 (5) |  |  |  |  |  |  |
| SA-10 (6) |  |  |  |  |  |  |
| SA-11 |yes |  |  | yes | x | x |
| SA-11a. |  |  |  |  |  |  |
| SA-11b. |  |  |  |  |  |  |
| SA-11c. |  |  |  |  |  |  |
| SA-11d. |  |  |  |  |  |  |
| SA-11e. |  |  |  |  |  |  |
| SA-11(1) |  |  |  |  |  |  |
| SA-11(2) |  |  |  |  |  |  |
| SA-11(3) |  |  |  |  |  |  |
| SA-11(3)(a) |  |  |  |  |  |  |
| SA-11(3)(b) |  |  |  |  |  |  |
| SA-11(4) |  |  |  |  |  |  |
| SA-11(5) |  |  |  |  |  |  |
| SA-11(6) |  |  |  |  |  |  |
| SA-11(7) |  |  |  |  |  |  |
| SA-11(8) |  |  |  |  |  |  |
| SA-12 | yes |  |  | yes |  | x | x |
| SA-12(1) |  |  |  |  |  |  |
| SA-12(2) |  |  |  |  |  |  |
| SA-12(3) |  |  |  |  |  |  |
| SA-12(4) |  |  |  |  |  |  |
| SA-12(5) |  |  |  |  |  |  |
| SA-12(6) |  |  |  |  |  |  |
| SA-12(7) |  |  |  |  |  |  |
| SA-12(8) |  |  |  |  |  |  |
| SA-12(9) |  |  |  |  |  |  |
| SA-12(10) |  |  |  |  |  |  |
| SA-12(11) |  |  |  |  |  |  |
| SA-12(12) |  |  |  |  |  |  |
| SA-12(13) |  |  |  |  |  |  |
| SA-12(14) |  |  |  |  |  |  |
| SA-12(15) |  |  |  |  |  |  |
| SA-13 |  |  |  |  |  |  |
| SA-13a. |  |  |  |  |  |  |
| SA-13b. |  |  |  |  |  |  |
| SA-14 |  |  |  |  |  |  |
| SA-14(1) |  |  |  |  |  |  |
| SA-15 | yes |  |  | yes |  | x |
| SA-15a. |  |  |  |  |  |  |
| SA-15a.1. |  |  |  |  |  |  |
| SA-15a.2. |  |  |  |  |  |  |
| SA-15a.3. |  |  |  |  |  |  |
| SA-15a.4. |  |  |  |  |  |  |
| SA-15b. |  |  |  |  |  |  |
| SA-15(1) |  |  |  |  |  |  |
| SA-15(1)(a) |  |  |  |  |  |  |
| SA-15(1)(b) |  |  |  |  |  |  |
| SA-15(2) |  |  |  |  |  |  |
| SA-15(3) |  |  |  |  |  |  |
| SA-15(4) |  |  |  |  |  |  |
| SA-15(4)(a) |  |  |  |  |  |  |
| SA-15(4)(b) |  |  |  |  |  |  |
| SA-15(4)(c) |  |  |  |  |  |  |
| SA-15(5) |  |  |  |  |  |  |
| SA-15(6) |  |  |  |  |  |  |
| SA-15(7) |  |  |  |  |  |  |
| SA-15(7)(a) |  |  |  |  |  |  |
| SA-15(7)(b) |  |  |  |  |  |  |
| SA-15(7)(c) |  |  |  |  |  |  |
| SA-15(7)(d) |  |  |  |  |  |  |
| SA-15(8) |  |  |  |  |  |  |
| SA-15(9) |  |  |  |  |  |  |
| SA-15(10) |  |  |  |  |  |  |
| SA-15(11) |  |  |  |  |  |  |
| SA-16 | yes |  |  | yes |  | x |
| SA-17 | yes |  |  | yes |  | x |
| SA-17a. |  |  |  |  |  |  |
| SA-17b. |  |  |  |  |  |  |
| SA-17c. |  |  |  |  |  |  |
| SA-17(1) |  |  |  |  |  |  |
| SA-17(1)(a) |  |  |  |  |  |  |
| SA-17(1)(b) |  |  |  |  |  |  |
| SA-17(2) |  |  |  |  |  |  |
| SA-17(2)(a) |  |  |  |  |  |  |
| SA-17(2)(b) |  |  |  |  |  |  |
| SA-17(3) |  |  |  |  |  |  |
| SA-17(3)(a) |  |  |  |  |  |  |
| SA-17(3)(b) |  |  |  |  |  |  |
| SA-17(3)(c) |  |  |  |  |  |  |
| SA-17(3)(d) |  |  |  |  |  |  |
| SA-17(3)(e) |  |  |  |  |  |  |
| SA-17(4) |  |  |  |  |  |  |
| SA-17(4)(a) |  |  |  |  |  |  |
| SA-17(4)(b) |  |  |  |  |  |  |
| SA-17(4)(c) |  |  |  |  |  |  |
| SA-17(4)(d) |  |  |  |  |  |  |
| SA-17(4)(e) |  |  |  |  |  |  |
| SA-17(5) |  |  |  |  |  |  |
| SA-17(5)(a) |  |  |  |  |  |  |
| SA-17(5)(b) |  |  |  |  |  |  |
| SA-17(6) |  |  |  |  |  |  |
| SA-17(7) |  |  |  |  |  |  |
| SA-18 |  |  |  |  |  |  |
| SA-18 (1) |  |  |  |  |  |  |
| SA-18 (2) |  |  |  |  |  |  |
| SA-19 |  |  |  |  |  |  |
| SA-19a. |  |  |  |  |  |  |
| SA-19b. |  |  |  |  |  |  |
| SA-19(1) |  |  |  |  |  |  |
| SA-19(2) |  |  |  |  |  |  |
| SA-19(3) |  |  |  |  |  |  |
| SA-19(4) |  |  |  |  |  |  |
| SA-20 |  |  |  |  |  |  |
| SA-21 | yes |  |  | yes |  |  |
| SA-21a. |  |  |  |  |  |  |
| SA-21b. |  |  |  |  |  |  |
| SA-21(1) |  |  |  |  |  |  |
| SA-22 |  |  | yes |  |  |  |
| SA-22a. |  |  |  |  |  |  |
| SA-22b. |  |  |  |  |  |  |
| SA-22(1) |  |  |  |  |  |  |
| SC-1 |yes |  |  | yes | x | x |
| SC-1a. |  |  |  |  |  |  |
| SC-1a.1. |  |  |  |  |  |  |
| SC-1a.2. |  |  |  |  |  |  |
| SC-1b. |  |  |  |  |  |  |
| SC-1b.1. |  |  |  |  |  |  |
| SC-1b.2. |  |  |  |  |  |  |
| SC-2 |  |  | yes |  | x | x |
| SC-2(1) |  |  |  |  |  |  |
| SC-3 |  |  | yes |  |  | x |
| SC-3(1) |  |  |  |  |  |  |
| SC-3(2) |  |  |  |  |  |  |
| SC-3(3) |  |  |  |  |  |  |
| SC-3(4) |  |  |  |  |  |  |
| SC-3(5) |  |  |  |  |  |  |
| SC-4 |  | yes |  |  | x | x |
| SC-4 (1) |  |  |  |  |  |  |
| SC-4 (2) |  |  |  |  |  |  |
| SC-5 |  | yes |  |  | x | x |
| SC-5 (1) |  |  |  |  |  |  |
| SC-5 (2) |  |  |  |  |  |  |
| SC-5 (3) |  |  |  |  |  |  |
| SC-5 (3)(a) |  |  |  |  |  |  |
| SC-5 (3)(b) |  |  |  |  |  |  |
| SC-6 |  |  |  |  |  |  |
| SC-7 |  | yes |  |  | x | x |
| SC-7a |  |  | yes |  | x | x |
| SC-7b |  |  | yes |  | x | x |
| SC-7c |yes |  |  | yes | x | x |
| SC-7(1) |  |  |  |  |  |  |
| SC-7(2) |  |  |  |  |  |  |
| SC-7(3) |  |  |  |  |  |  |
| SC-7(4) |  |  |  |  |  |  |
| SC-7(4)(a) |  |  |  |  |  |  |
| SC-7(4)(b) |  |  |  |  |  |  |
| SC-7(4)(c) |  | yes |  |  | x | x |
| SC-7(4)(d) |  |  |  |  |  |  |
| SC-7(4)(e) |  |  |  |  |  |  |
| SC-7(5) |  | yes |  |  | x | x |
| SC-7(6) |  |  |  |  |  |  |
| SC-7(7) | yes |  |  |  |  |  |
| SC-7(8) |  | coming soon |  |  |  | x |
| SC-7(9) |  |  |  |  |  |  |
| SC-7(9)(a) |  |  |  |  |  |  |
| SC-7(9)(b) |  |  |  |  |  |  |
| SC-7(10) |  |  |  |  |  |  |
| SC-7(11) |  |  |  |  |  |  |
| SC-7(12) |  |  |  |  |  |  |
| SC-7(13) |  |  |  |  |  |  |
| SC-7(14) |  |  |  |  |  |  |
| SC-7(15) |  |  |  |  |  |  |
| SC-7(16) |  |  |  |  |  |  |
| SC-7(17) |  |  |  |  |  |  |
| SC-7(18) |  | yes |  | yes |  | x |
| SC-7(19) |  |  |  |  |  |  |
| SC-7(20) |  |  |  |  |  |  |
| SC-7(21) |  |  |  |  |  |  |
| SC-7(22) |  |  |  |  |  |  |
|SC-7(23) |  |  |  |  |  |  |
| SC-8 |  | yes |  | yes | x | x |
| SC-8(1) |  |  |  |  |  |  |
| SC-8(2) |  |  |  |  |  |  |
| SC-8(3) |  |  |  |  |  |  |
| SC-8(4) |  |  |  |  |  |  |
| SC-9 |  |  |  |  |  |  |
| SC-10 |  | yes |  | yes | x | x |
| SC-11 |  |  |  |  |  |  |
| SC-11 (1) |  |  |  |  |  |  |
| SC-12 |yes |  |  | yes | x | x |
| SC-12(1) |  |  |  |  |  |  |
| SC-12(2) |  |  |  |  |  |  |
| SC-12(3) |  |  |  |  |  |  |
| SC-12(4) |  |  |  |  |  |  |
| SC-12(5) |  |  |  |  |  |  |
| SC-13 |yes |  |  | yes | x | x |
| SC-13 1) |  |  |  |  |  |  |
| SC-13(2) |  |  |  |  |  |  |
| SC-13(3) |  |  |  |  |  |  |
| SC-13(4) |  |  |  |  |  |  |
| SC-14 |  |  |  |  |  |  |
| SC-15 |yes |  |  | yes | x | x |
| SC-15a. |  |  |  |  |  |  |
| SC-15b. |  |  |  |  |  |  |
| SC-15(1) |  |  |  |  |  |  |
| SC-15(2) |  |  |  |  |  |  |
| SC-15(3) |  |  |  |  |  |  |
| SC-15(4) |  |  |  |  |  |  |
| SC-16 |  |  |  |  |  |  |
| SC-16(1) |  |  |  |  |  |  |
| SC-17 |yes |  |  | yes | x | x |
| SC-18 |yes |  |  | yes | x | x |
| SC-18a. |  |  |  |  |  |  |
| SC-18b. |  |  |  |  |  |  |
| SC-18c. |  |  |  |  |  |  |
| SC-18(1) |  |  |  |  |  |  |
| SC-18(2) |  |  |  |  |  |  |
| SC-18(3) |  |  |  |  |  |  |
| SC-18(4) |  |  |  |  |  |  |
| SC-18(5) |  |  |  |  |  |  |
| SC-19 |yes |  |  | yes | x | x |
| SC-19a. |  |  |  |  |  |  |
| SC-19b. |  |  |  |  |  |  |
| SC-20 |yes |  |  | yes | x | x |
| SC-20a. |  |  |  |  |  |  |
| SC-20b. |  |  |  |  |  |  |
| SC-20(1) |  |  |  |  |  |  |
| SC-20(2) |  |  |  |  |  |  |
| SC-21 |  | yes |  |  | x | x |
| SC-21(1) |  |  |  |  |  |  |
| SC-22 |  |  | yes |  | x | x |
| SC-23 |  |  | yes |  | x | x |
| SC-23(1) |  |  |  |  |  |  |
| SC-23(2) |  |  |  |  |  |  |
| SC-23(3) |  |  |  |  |  |  |
| SC-23(4) |  |  |  |  |  |  |
| SC-23(5) |  |  |  |  |  |  |
| SC-24 | yes |  |  | yes |  | x |
| SC-25 |  |  |  |  |  |  |
| SC-26 |  |  |  |  |  |  |
| SC-26(1) |  |  |  |  |  |  |
| SC-27 |  |  |  |  |  |  |
| SC-28 |yes |  |  | yes | x | x |
| SC-28(1) |  |  |  |  |  |  |
| SC-28(2) |  |  |  |  |  |  |
| SC-29 |  |  |  |  |  |  |
| SC-29(1) |  |  |  |  |  |  |
| SC-30 |  |  |  |  |  |  |
| SC-30(1) |  |  |  |  |  |  |
| SC-30(2) |  |  |  |  |  |  |
| SC-30(3) |  |  |  |  |  |  |
| SC-30(4) |  |  |  |  |  |  |
| SC-30(5) |  |  |  |  |  |  |
| SC-31 |  |  |  |  |  |  |
| SC-31a. |  |  |  |  |  |  |
| SC-31b. |  |  |  |  |  |  |
| SC-31(1) |  |  |  |  |  |  |
| SC-31(2) |  |  |  |  |  |  |
| SC-31(3) |  |  |  |  |  |  |
| SC-32 |  |  |  |  |  |  |
| SC-33 |  |  |  |  |  |  |
| SC-34 |  |  |  |  |  |  |
| SC-34a. |  |  |  |  |  |  |
| SC-34b. |  |  |  |  |  |  |
| SC-34(1) |  |  |  |  |  |  |
| SC-34(2) |  |  |  |  |  |  |
| SC-34(3) |  |  |  |  |  |  |
| SC-34(3)(a) |  |  |  |  |  |  |
| SC-34(3)(b) |  |  |  |  |  |  |
| SC-35 |  |  |  |  |  |  |
| SC-36 |  |  |  |  |  |  |
| SC-36(1) |  |  |  |  |  |  |
| SC-37 |  |  |  |  |  |  |
| SC-37(1) |  |  |  |  |  |  |
| SC-38 |  |  |  |  |  |  |
| SC-39 |  | yes |  |  | x | x |
| SC-39(1) |  |  |  |  |  |  |
| SC-39(2) |  |  |  |  |  |  |
| SC-40 |  |  |  |  |  |  |
| SC-40(1) |  |  |  |  |  |  |
| SC-40(2) |  |  |  |  |  |  |
| SC-40(3) |  |  |  |  |  |  |
| SC-40(4) |  |  |  |  |  |  |
| SC-41 |  |  |  |  |  |  |
| SC-42 |  |  |  |  |  |  |
| SC-42a. |  |  |  |  |  |  |
| SC-42b. |  |  |  |  |  |  |
| SC-42(1) |  |  |  |  |  |  |
| SC-42(2) |  |  |  |  |  |  |
| SC-42(3) |  |  |  |  |  |  |
| SC-43 |  |  |  |  |  |  |
| SC-43a. |  |  |  |  |  |  |
| SC-43b. |  |  |  |  |  |  |
| SC-44 |  |  |  |  |  |  |
| SI-1 |yes |  |  | yes | x | x |
| SI-1a. |  |  |  |  |  |  |
| SI-1a.1. |  |  |  |  |  |  |
| SI-1a.2. |  |  |  |  |  |  |
| SI-1b. |  |  |  |  |  |  |
| SI-1b.1. |  |  |  |  |  |  |
| SI-1b.2. |  |  |  |  |  |  |
| SI-2 |  |  | yes |  | x | x |
| SI-2a. |  |  |  |  |  |  |
| SI-2b. |  |  |  |  |  |  |
| SI-2c. |  |  |  |  |  |  |
| SI-2d. |  |  |  |  |  |  |
| SI-2(1) |  |  |  |  |  |  |
| SI-2(2) |  |  |  |  |  |  |
| SI-2(3) |  |  |  |  |  |  |
| SI-2(3)(a) |  |  |  |  |  |  |
| SI-2(3)(b) |  |  |  |  |  |  |
| SI-2(4) |  |  |  |  |  |  |
| SI-2(5) |  |  |  |  |  |  |
| SI-2(6) |  |  |  |  |  |  |
| SI-3 |  |  | yes |  | x | x |
| SI-3a. |  |  |  |  |  |  |
| SI-3b. |  |  |  |  |  |  |
| SI-3c. |  |  |  |  |  |  |
| SI-3c.1. |  |  |  |  |  |  |
| SI-3c.2. |  |  |  |  |  |  |
| SI-3d. |  |  |  |  |  |  |
| SI-3(1) |  |  |  |  |  |  |
| SI-3(2) |  |  |  |  |  |  |
| SI-3(3) |  |  |  |  |  |  |
| SI-3(4) |  |  |  |  |  |  |
| SI-3(5) |  |  |  |  |  |  |
| SI-3(6) |  |  |  |  |  |  |
| SI-3(6)(a) |  |  |  |  |  |  |
| SI-3(6)(b) |  |  |  |  |  |  |
| SI-3(7) |  |  |  |  |  |  |
| SI-3(8) |  |  |  |  |  |  |
| SI-3(9) |  |  |  |  |  |  |
| SI-3(10) |  |  |  |  |  |  |
| SI-3(10)(a) |  |  |  |  |  |  |
| SI-3(10)(b) |  |  |  |  |  |  |
| SI-4 |  |  | yes |  | x | x |
|SI-4a. |  |  |  |  |  |  |
| SI-4a.1. |  |  |  |  |  |  |
| SI-4a.2. |  |  |  |  |  |  |
| SI-4b. |  |  |  |  |  |  |
| SI-4c. |  |  |  |  |  |  |
| SI-4c.1. |  |  |  |  |  |  |
| SI-4c.2. |  |  |  |  |  |  |
| SI-4d. |  |  |  |  |  |  |
| SI-4e. |  |  |  |  |  |  |
| SI-4f. |  |  |  |  |  |  |
| SI-4g. |  |  |  |  |  |  |
| SI-4(1) |  |  |  |  |  |  |
| SI-4(2) |  |  |  |  |  |  |
| SI-4(3) |  |  |  |  |  |  |
| SI-4(4) |  |  |  |  |  |  |
| SI-4(5) |  |  |  |  |  |  |
| SI-4(6) |  |  |  |  |  |  |
| SI-4(7) |  |  |  |  |  |  |
| SI-4(8) |  |  |  |  |  |  |
| SI-4(9) |  |  |  |  |  |  |
| SI-4(10) |  |  |  |  |  |  |
| SI-4(11) |  |  |  |  |  |  |
| SI-4(12) |  |  |  |  |  |  |
| SI-4(13) |  |  |  |  |  |  |
| SI-4(13)(a) |  |  |  |  |  |  |
| SI-4(13)(b) |  |  |  |  |  |  |
| SI-4(13)(c) |  |  |  |  |  |  |
| SI-4(14) |  |  |  |  |  |  |
| SI-4(15) |  |  |  |  |  |  |
| SI-4(16) |  |  |  |  |  |  |
| SI-4(17) |  |  |  |  |  |  |
| SI-4(18) |  |  |  |  |  |  |
| SI-4(19) |  |  |  |  |  |  |
| SI-4(20) |  |  |  |  |  |  |
| SI-4(21) |  |  |  |  |  |  |
| SI-4(22) |  |  |  |  |  |  |
| SI-4(23) |  |  |  |  |  |  |
| SI-4(24) |  |  |  |  |  |  |
| SI-5 |  |  | yes |  | x | x |
| SI-5a. |  |  |  |  |  |  |
| SI-5b. |  |  |  |  |  |  |
| SI-5c. |  |  |  |  |  |  |
| SI-5d. |  |  |  |  |  |  |
| SI-5(1) |  |  |  |  |  |  |
| SI-6 |  |  | yes |  |  | x |
| SI-6a |  |  | yes |  |  | x |
| SI-6b |  |  | yes |  |  | x |
| SI-6c |  |  | yes |  |  | x |
| SI-6d |  |  | yes |  |  | x |
| SI-6(1) |  |  |  |  |  |  |
| SI-6(2) |  |  |  |  |  |  |
| SI-6(3) |  |  |  |  |  |  |
| SI-7 |yes |  |  | yes | x | x |
| SI-7(1) |yes |  |  | yes | x | x |
| SI-7(2) | yes |  |  | yes |  | x |
| SI-7(3) |  |  |  |  |  |  |
| SI-7(4) |  |  |  |  |  |  |
| SI-7(5) | yes |  |  | yes |  | x |
| SI-7(6) |  |  |  |  |  |  |
| SI-7(7) |  |  |  |  |  |  |
| SI-7(8) |  |  |  |  |  |  |
| SI-7(9) |  |  |  |  |  |  |
| SI-7(10) |  |  |  |  |  |  |
| SI-7(11) |  |  |  |  |  |  |
| SI-7(12) |  |  |  |  |  |  |
| SI-7(13) |  |  |  |  |  |  |
| SI-7(14) |  |  |  |  |  |  |
| SI-7(14)(a) |  |  |  |  |  |  |
| SI-7(14)(b) |  |  |  |  |  |  |
| SI-7(15) |  |  |  |  |  |  |
| SI-7(16) |  |  |  |  |  |  |
| SI-8 |yes |  |  | yes | x | x |
| SI-8a. |  |  |  |  |  |  |
| SI-8b. |  |  |  |  |  |  |
| SI-8(1) |  |  |  |  |  |  |
| SI-8(2) |  |  |  |  |  |  |
| SI-8(3) |  |  |  |  |  |  |
| SI-9 |  |  |  |  |  |  |
| SI-10 |yes |  |  | yes | x | x |
| SI-10(1) |  |  |  |  |  |  |
| SI-10(1)(a) |  |  |  |  |  |  |
| SI-10(1)(b) |  |  |  |  |  |  |
| SI-10(1)(c) |  |  |  |  |  |  |
| SI-10(2) |  |  |  |  |  |  |
| SI-10(3) |  |  |  |  |  |  |
| SI-10(4) |  |  |  |  |  |  |
| SI-10(5) |  |  |  |  |  |  |
| SI-11 |yes |  |  | yes | x | x |
| SI-11a. |  |  |  |  |  |  |
| SI-11b. |  |  |  |  |  |  |
| SI-12 |yes |  |  | yes | x | x |
| SI-13 |  |  |  |  |  |  |
| SI-13a. |  |  |  |  |  |  |
| SI-13b. |  |  |  |  |  |  |
| SI-13(1) |  |  |  |  |  |  |
| SI-13(2) |  |  |  |  |  |  |
| SI-13(3) |  |  |  |  |  |  |
| SI-13(4) |  |  |  |  |  |  |
| SI-13(4)(a) |  |  |  |  |  |  |
| SI-13(4)(b) |  |  |  |  |  |  |
| SI-13(5) |  |  |  |  |  |  |
| SI-14 |  |  |  |  |  |  |
| SI-14(1) |  |  |  |  |  |  |
| SI-15 |  |  |  |  |  |  |
| SI-16 |  | yes |  |  | x | x |
| SI-17 |  |  |  |  |  |  |
| PM-1 |  |  |  |  |  |  |
| PM-1a. |  |  |  |  |  |  |
| PM-1a.1. |  |  |  |  |  |  |
| PM-1a.2. |  |  |  |  |  |  |
| PM-1a.3. |  |  |  |  |  |  |
| PM-1a.4. |  |  |  |  |  |  |
| PM-1b. |  |  |  |  |  |  |
| PM-1c. |  |  |  |  |  |  |
| PM-1d. |  |  |  |  |  |  |
| PM-2 |  |  |  |  |  |  |
| PM-3 |  |  |  |  |  |  |
| PM-3a. |  |  |  |  |  |  |
| PM-3b. |  |  |  |  |  |  |
| PM-3c. |  |  |  |  |  |  |
| PM-4 |  |  |  |  |  |  |
| PM-4a. |  |  |  |  |  |  |
| PM-4a.1. |  |  |  |  |  |  |
| PM-4a.2. |  |  |  |  |  |  |
| PM-4a.3. |  |  |  |  |  |  |
| PM-4b. |  |  |  |  |  |  |
| PM-5 |  |  |  |  |  |  |
| PM-6 |  |  |  |  |  |  |
| PM-7 |  |  |  |  |  |  |
| PM-8 |  |  |  |  |  |  |
| PM-9 |  |  |  |  |  |  |
| PM-9a. |  |  |  |  |  |  |
| PM-9b. |  |  |  |  |  |  |
| PM-9c. |  |  |  |  |  |  |
| PM-10 |  |  |  |  |  |  |
| PM-10a. |  |  |  |  |  |  |
| PM-10b. |  |  |  |  |  |  |
| PM-10c. |  |  |  |  |  |  |
| PM-11 |  |  |  |  |  |  |
| PM-11a. |  |  |  |  |  |  |
| PM-11b. |  |  |  |  |  |  |
| PM-12 |  |  |  |  |  |  |
| PM-13 |  |  |  |  |  |  |
| PM-14 |  |  |  |  |  |  |
| PM-14a. |  |  |  |  |  |  |
| PM-14a.1. |  |  |  |  |  |  |
| PM-14a.2. |  |  |  |  |  |  |
| PM-14b. |  |  |  |  |  |  |
| PM-15 |  |  |  |  |  |  |
| PM-15a. |  |  |  |  |  |  |
| PM-15b. |  |  |  |  |  |  |
| PM-15c. |  |  |  |  |  |  |
| PM-16 |  |  |  |  |  |  |
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
| SR-12 |  |  |  |  |  |  |