# ezdrp helm

## Przygotowanie do instalacji aplikacji
- Przed przystapieniem do instalacji aplikacji nalezy wygenerowac certyfikat wildcard dla domeny pod ktora dostepna bedzie aplikacja.
Certyfikat nastepnie nalezy umiescic w **namespace** w ktorym bedzie instalowana aplikacja.

- Jezeli aplikacja jest instalowana w wersji produkcyjnej nalezy przygotowac zewnetrzne bazy danych:
  **Relacyjne**:
  Aplikacja zostala przystosowana do uzycia jednej z poniższych relacyjnych instancji baz danych.
  - **PostgreSQL** - Testowane na minimalnej wersji`11.5`.
  - **MsSQL**      - Server w wersji 2019.
  **Nierelacyjne:**
  - **MongoDB**    - Testowane na minimalnej wersji `4.4.5`.
  - **Redis**      - Testowane na minimalnej wersji `5.0.12`.
  - **Redis**      - Testowane na minimalnej wersji `5.0.12`. W konfiguracji **append only**.
  - **MinIO**      - Testowane na minimalnej wersji `RELEASE 2021-06-17T00-10-46Z .
  **Message Broker:
  - **RabbitMQ**   - Testowane na minimalnej wersji `3.8.9`.



## Image Credentials

imageCredentials:\
  registryDomain: "hub.eadministracja.nask.pl/ezdrp" - adres rejestru z którego zostaną ściągnięte kontenery aplikacji - Tego nie zmieniamy

## storage
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|------------------------|
| storage.enable      | `boolean`        | `true`                | ✗                      |
| storage.class       | `String`         | `longhorn`            | ✓                      |

Domyslnie ustawiony jest **longhorn**. Mozliwa jest zmiana pod wlasna konfiguracje. W tym celu nalezy podac nazwe klasy swojego persistent storage. Np. `class: &storageclass "twoja_nazwa"`



## domainInfo
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|------------------------|
| domainInfo.name     | `String`         | `project.domain.pl`   | ✓                      |
| domainInfo.cert_name| `String`         | `longhorn`            | ✓                      |

- **domainInfo.name** - Glowna domena (np. domena.pl) do ktorej dolaczane sa przedrostki aplikacji. Np. `ezdrp-web`. Efekt koncowy powinien wygladac tak `ezdrp-web.domena.pl`.
- **domainInfo.cert_name** - Nazwa dodanego wczesniej certyfikatu.



## relationalDbExt
| **Zmienna**              | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|--------------------------|------------------|-----------------------|------------------------|
| relationalDbExt.user     | `String`         | `postgres`     | ✓                             |
| relationalDbExt.password | `String`         | `changeme`     | ✓                             |
| relationalDbExt.dbname   | `String`         | `ezdrp`        | ✓                             |
| relationalDbExt.host     | `String`         | `localhost`    | ✓                             |
| relationalDbExt.port     | `int`            | `5432`         | ✓                             |

Connection string do relacyjnej bazy danych - jednej z trzech mozliwych do wyboru (tylko w instalacji srodowiska produkcyjnego).
*W przypadku instalacji testowej nalezy pozostawic zmienne domyslne.*



## relationaldbInt
| **Zmienna**                        | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|------------------------------------|------------------|-----------------------|------------------------|
| relationalDbInt.useExistingSecret  | `String`         | `relationaldb-config` | ✗                      |

Wybor secretu z danymi do polaczenia z baza danych - jedna z trzech mozliwych do wyboru (tylko w instalacji srodowiska testowego, instalowanego z helm chart **ezdrp-db-dev**).
*W przypadku wyboru instalacji produkcyjnej nie nalezy zmieniac tej opcji.*



## mongoExt
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|------------------------|
| mongoExt.user       | `String`         | `ezdrpadmin`          | ✓                      |
| mongoExt.password   | `String`         | `changeme`            | ✓                      |
| mongoExt.dbname     | `String`         | `ezdrp`               | ✓                      |
| mongoExt.host       | `String`         | `localhost`           | ✓                      |
| mongoExt.port       | `int`            | `27017`               | ✓                      |

Connection string do relacyjnej bazy danych MongoDb (tylko w instalacji srodowiska produkcyjnego).
*W przypadku instalacji testowej nalezy pozostawic zmienne domyslne.*



## mongoInt
| **Zmienna**                 | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|-----------------------------|------------------|-----------------------|------------------------|
| mongoInt.useExistingSecret  | `String`         | `mongodb-config`      | ✗                      |

Wybor secretu dla MongoDb do polaczenia z baza danych (tylko w instalacji srodowiska testowego, instalowanego z helm chart **ezdrp-db-dev**).
*W przypadku wyboru instalacji produkcyjnej nie nalezy zmieniac tej opcji.*



## rabbitExt
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|------------------------|
| rabbitExt.user      | `String`         | `ezdrpadmin`          | ✓                      |
| rabbitExt.password  | `String`         | `changeme`            | ✓                      |
| rabbitExt.dbname    | `String`         | `ezdrp`               | ✓                      |
| rabbitExt.host      | `String`         | `localhost`           | ✓                      |
| rabbitExt.port      | `int`            | `5672`                | ✓                      |

Connection string do Redis (tylko w instalacji srodowiska produkcyjnego).
W przypadku instalacji testowej nalezy pozostawic zmienne domyslne.



## rabbitInt
| **Zmienna**                 | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|-----------------------------|------------------|-----------------------|------------------------|
| rabbitInt.useExistingSecret | `String`         | `rabbit-config`       | ✗                      |

Wybor secretu dla RabbitMQ (tylko w instalacji srodowiska testowego, instalowanego z helm chart **ezdrp-db-dev**).
*W przypadku wyboru instalacji produkcyjnej nie nalezy zmieniac tej opcji.*



## minioExt
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|------------------------|
| minioExt.user       | `String`         | `ezdrpadmin`          | ✓                      |
| minioExt.password   | `String`         | `changeme`            | ✓                      |
| minioExt.bucket     | `String`         | `documents`           | ✓                      |
| minioExt.host       | `String`         | `localhost`           | ✓                      |
| minioExt.port       | `int`            | `9000`                | ✓                      |
 
Connection string do MinIO (tylko w instalacji srodowiska produkcyjnego).
*W przypadku instalacji testowej nalezy pozostawic zmienne domyslne.*



## minioInt
| **Zmienna**                 | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|-----------------------------|------------------|-----------------------|------------------------|
| minioInt.useExistingSecret  | `String`         | `minioInt`            | ✗                      |

Wybor secretu dla MinIO (tylko w instalacji srodowiska testowego, instalowanego z helm chart **ezdrp-db-dev**).
*W przypadku wyboru instalacji produkcyjnej nie nalezy zmieniac tej opcji.*



## redisAppendExt
| **Zmienna**            | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|------------------------|------------------|-----------------------|------------------------|
| redisAppendExt.password| `String`         | `changeme`            | ✓                      |
| redisAppendExt.host    | `String`         | `localhost`           | ✓                      |
| redisAppendExt.port    | `int`            | `6379`                | ✓                      |

Connection string dla Redis w wersji **Append only** (tylko w instalacji srodowiska produkcyjnego).
*W przypadku instalacji testowej nalezy pozostawic zmienne domyslne.*



## redisAppendInt
| **Zmienna**                      | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|----------------------------------|------------------|-----------------------|------------------------|
| redisAppendInt.useExistingSecret | `String`         | `redis-append-config` | ✗                      |

Wybor secretu dla Redis w wersji **Append only** (tylko w instalacji srodowiska testowego, instalowanego z helm chart **ezdrp-db-dev**).
*W przypadku wyboru instalacji produkcyjnej nie nalezy zmieniac tej opcji.*



## waitfor
| **Zmienna**            | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|------------------------|------------------|-----------------------|------------------------|
| waitfor.image.name     | `String`         | `wait_for`            | ✗                      |
| waitfor.image.version  | `String`         | `01`                  | ✗                      |
| waitfor.image.registry | `pointer`        | `*registry`           | ✗                      |

Jest to obraz sidecara do oczekiwania powolanie wymaganych zaleznosci konkretnych modulow.



## email
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|-------------------------|
| email.host          | `String`         | `example.mail.server` | ✓                       |
| email.port          | `int`            | `587`                 | ✓                       |
| email.sendermail    | `String`         | `sendermail@domain`   | ✓                       |
| email.sendername    | `String`         | `sendername@domain`   | ✓                       |
| email.password      | `String`         | `changeme`            | ✓                       |



## cloudadmin
*Modul **CloudAdmin** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*
| **Zmienna**         | **Typ wartosci** | **Domyslna wartosc**  | **Wymagane do zmiany?** |
|---------------------|------------------|-----------------------|-------------------------|
| **cloudadmin**          |        |  |                     |
| cloudadmin.active              | `boolean`            | `true`                 | ✗                       |
| **cloudadmin.image**               |         |   |                       |
| cloudadmin.image.name    | `String`         | `ezdrp-cloudadmin`   | ✗                       |
| cloudadmin.image.version      | `String`         | `1.0.196`            | ✗                       |
| cloudadmin.moduleName      | `String`         | `cloudadmin`            | ✗                       |
| cloudadmin.port      | `int`         | `2000`            | ✗                       |
| cloudadmin.delaySeconds      | `int`         | `30`            | ✗                       |
| **cloudadmin.resources**      |        |           |                       |
| cloudadmin.resources.**limits**      |         |            |                      |
| cloudadmin.resources.limits.cpu      | `String`         | `300m`            | ✗                       |
| cloudadmin.resources.limits.memory   | `String`         | `300m`            | ✗                       |
| cloudadmin.resources.**requests**      |         |            |                       |
| cloudadmin.resources.cpu      | `String`         | `100m`            | ✗                       |
| cloudadmin.resources.memory      | `String`         | `128Mi`            | ✗                       |
| **cloudadmin.relationaldb**     |         |          |                        |
| cloudadmin.relationaldb.**dbname**     |         |             |                        |
| cloudadmin.relationaldb.dbname.ezdrp     | `String`         | `String`            | ✗                       |
| cloudadmin.relationaldb.dbname.archiwum      | `String`         | `archiwum`            | ✗                       |
| cloudadmin.relationaldb.dbname.crm      | `String`         | `crm`            | ✗                       |
| **cloudadmin.rabbit**     |      |           |                      |
| cloudadmin.rabbit.confirms      | `boolean`         | `true`            | ✗                       |
| cloudadmin.rabbit.**dbname**      |         |             |                     |
| cloudadmin.rabbit.dbname.archiwum      | `String`         | `arch`            | ✗                       |
| **cloudadmin.redis**      |      |            |                        |
| cloudadmin.redis.serviceName      | `String`         | `mymaster`            | ✗                       |
| **cloudadmin.elastic**      |        |            |                     |
| cloudadmin.elastic.host      | `String`         | `elasticsearch`            | ✗                       |
| cloudadmin.elastic.port      | `int`         | `8200`            | ✗                       |
| **cloudadmin.filerepository**      |        |           |                     |
| cloudadmin.filerepository.host      | `String`         | `filerepository`            | ✗                       |
| cloudadmin.filerepository.name      | `int`         | `5000`            | ✗                       |
| **cloudadmin.api**      |         |            |                       |
| cloudadmin.api.host      | `String`         | `ezdrp-api`            | ✗                       |
| cloudadmin.api.port      | `int`         | `5000`            | ✗                       |
| **cloudadmin.archiwum**      |        |            |                      |
| cloudadmin.archiwum.host      | `String`         | `archiwum-api`            | ✗                       |
| cloudadmin.archiwum.port      | `int`         | `5000`            | ✗                       |
| **cloudadmin.kuip**      |        |           |                       |
| cloudadmin.kuip.host      | `String`         | `kuip-api`            | ✗                       |
| cloudadmin.kuip.port      | `String`         | `5000`            | ✗                       |
| **cloudadmin.sso**      |         |             |                       |
| cloudadmin.sso.host      | `String`         | `sso-identityserver`            | ✗                       |
| **cloudadmin.guardian**      |          |             |                        |
| cloudadmin.guardian.host      | `String`         | `guardprotector`            | ✗                       |



<br/>
<br/>
<br/>

## anonimizator
*Modul **anonimizator** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*



## archiwumApi
*Modul **archiwumApi** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## archiwumWeb
*Modul **archiwumWeb** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*



## ezdrpApi
*Modul **ezdrpApi** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## ezdrpWeb
*Modul **ezdrpWeb** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*



## filerepository
*Modul **filerepository** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*



## kuipWeb
*Modul **kuipWeb** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## ocrApi
*Modul **ocrApi** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## razor
*Modul **razor** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## ssoApigateway:
*Modul **ssoApigateway** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## ssoExternalProviders:
*Modul **ssoExternalProviders** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*





## ssoIdentityServer:
*Modul **ssoIdentityServer** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## ticketmanager:
*Modul **ticketmanager** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## wpeRest:
*Modul **wpeRest** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*




## wpeWeb:
*Modul **wpeWeb** jest integralna czescia aplikacji i nie nalezy wprowadzac w nim jakichkolwiek zmian.*






