CREATE TABLE EmpresaDocumentosSAT
(
	IdEmpresaDocumento BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	RFC VARCHAR(13) NOT NULL,
	Token, --RESUELVE EL BLOB?
    TipoDocumentoSAT VARCHAR(30) NOT NULL,
    -- CSF
    -- OPINION_CUMPLIMIENTO
    -- DECLARACION
    -- ACUSE_DECLARACION
    -- RECIBO_PAGO_DECLARACION
    -- LINEA_CAPTURA
    -- OTRO
    SubtipoDocumentoSAT VARCHAR(100) NULL,
    -- DECLARACION_PROVISIONAL_DEFINITIVA
    -- DECLARACION_ANUAL
    -- DECLARACION_PAGADA
    -- ACUSE
    -- RECIBO_PAGO
	-- OTRO
    PortalOrigen VARCHAR(80) NULL,
    -- SAT_CSF
    -- SAT_OPINION
    -- SAT_DECLARACIONES_NUEVO
    -- SAT_DECLARACIONES_VIEJO
    -- SAT_DECLARACIONES_PAGADAS
    -- OTRO
    NombreArchivoOriginal NVARCHAR(300) NULL,
    NombreArchivoSistema NVARCHAR(300) NOT NULL,
    Extension VARCHAR(20) NULL,
    MimeType VARCHAR(100) NULL,
    HashArchivo VARCHAR(128) NOT NULL, --Para identificar un documento único RFC + TipoDocumentoSAT + Hash
    -- SHA256 recomendado
    TamanoBytes BIGINT NULL,
    FechaEmisionDocumento DATETIME2 NULL, --Habría que ver si todos los documentos cuentan con este dato
    FechaDescarga DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaInicioVigencia DATETIME2 NULL, --Para mostrar al usuario
    FechaFinVigencia DATETIME2 NULL, --Para mostrar al usuario
    EsVigente BIT NOT NULL DEFAULT 0,
    EstatusDocumento VARCHAR(50) NOT NULL DEFAULT 'Descargado',
    -- Descargado
    -- Procesado
    -- ErrorLectura
    -- Finalizado
	-- ...
    EstatusLectura VARCHAR(50) NULL,
    -- Pendiente
    -- Leido
    -- Error
    -- NoRequiereLectura
    TextoExtraido NVARCHAR(MAX) NULL,
	VersionParser VARCHAR(10) NULL,
	MensajeErrorDescarga NVARCHAR(MAX) NULL,
	MensajeErrorLectura NVARCHAR(MAX) NULL,
    -- Útil para auditoría y reprocesamiento.
    FechaCreacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaModificacion DATETIME2 NULL
);

CREATE TABLE EmpresaConstanciasSituacionFiscal
(
    IdEmpresaConstanciaSituacionFiscal BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaDocumentoSAT BIGINT NOT NULL, --Relaciona documento
	RFC VARCHAR(13) NOT NULL,
    IdCIF VARCHAR(50) NULL,
    LugarEmision NVARCHAR(200) NULL,
    FechaEmision DATE NULL,
    EsVigente BIT NOT NULL DEFAULT 0,
    HashDatosNormalizados VARCHAR(128) NULL,
    FechaCreacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaModificacion DATETIME2 NULL
);

CREATE TABLE EmpresaCSFDatosIdentificacion
(
    IdEmpresaCSFDatosIdentificacion BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaConstanciaSituacionFiscal BIGINT NOT NULL,
    RFC VARCHAR(13) NOT NULL,
    RazonSocial NVARCHAR(300) NULL,
    RegimenCapital NVARCHAR(200) NULL,
    NombreComercial NVARCHAR(300) NULL,
    FechaInicioOperaciones DATE NULL,
    EstatusPadron VARCHAR(100) NULL,
    FechaUltimoCambioEstado DATE NULL
);

Ej.
RFC: PFE140312IW8
Razón social: PROVEEDORES DE FACTURACION ELECTRONICA Y SOFTWARE
Régimen capital: SOCIEDAD ANONIMA DE CAPITAL VARIABLE
Nombre comercial: PROFACT
Fecha inicio operaciones: 12/03/2014
Estatus padrón: ACTIVO
Fecha último cambio estado: 10/04/2014

CREATE TABLE EmpresaCSFDomicilios
(
    IdEmpresaCSFDomicilio BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaConstanciaSituacionFiscal BIGINT NOT NULL,
    CodigoPostal VARCHAR(10) NULL,
    TipoVialidad NVARCHAR(100) NULL,
    NombreVialidad NVARCHAR(300) NULL,
    NumeroExterior NVARCHAR(50) NULL,
    NumeroInterior NVARCHAR(50) NULL,
    Colonia NVARCHAR(300) NULL,
    Localidad NVARCHAR(300) NULL,
    MunicipioDemarcacion NVARCHAR(300) NULL,
    EntidadFederativa NVARCHAR(300) NULL,
    EntreCalle NVARCHAR(300) NULL,
    YCalle NVARCHAR(300) NULL,
    CorreoElectronico NVARCHAR(300) NULL,
    TelefonoFijoLada VARCHAR(10) NULL,
    TelefonoFijoNumero VARCHAR(30) NULL,
    TelefonoMovilLada VARCHAR(10) NULL,
    TelefonoMovilNumero VARCHAR(30) NULL,
    EstadoDomicilio NVARCHAR(200) NULL,
    EstadoContribuyenteDomicilio NVARCHAR(200) NULL
);

Ej. 
Código postal: 53100
Tipo vialidad: CALLE
Nombre vialidad: FERNANDO LEAL NOVELO
Número exterior: 7
Número interior: 302
Colonia: CIUDAD SATELITE
Municipio: NAUCALPAN DE JUAREZ
Entidad: MEXICO
Entre calle: CARLOS ARELLANO
Y calle: ENRIQUE SADA MORGUEZA

CREATE TABLE EmpresaCSFActividadesEconomicas
(
    IdEmpresaCSFActividadEconomica BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaConstanciaSituacionFiscal BIGINT NOT NULL,
    Orden INT NULL,
    ActividadEconomica NVARCHAR(500) NOT NULL,
    Porcentaje DECIMAL(9,4) NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL
);

Ej.
Orden: 1
Actividad: Servicios de consultoría en computación
Porcentaje: 100
Fecha inicio: 12/03/2014

CREATE TABLE EmpresaCSFRegimenes
(
    IdEmpresaCSFRegimen BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaConstanciaSituacionFiscal BIGINT NOT NULL,
    Regimen NVARCHAR(300) NOT NULL,
    FechaInicio DATE NULL,
    FechaFin DATE NULL
);

Ej.
Régimen General de Ley Personas Morales
Fecha inicio: 12/03/2014

CREATE TABLE EmpresaCSFObligaciones
(
    IdEmpresaCSFObligacion BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IdEmpresaConstanciaSituacionFiscal BIGINT NOT NULL,
    Orden INT NULL,
    DescripcionObligacion NVARCHAR(700) NOT NULL,
    DescripcionVencimiento NVARCHAR(700) NULL,
    PeriodicidadDetectada VARCHAR(50) NULL,
    -- Mensual
    -- Anual
    -- Trimestral
    -- SinDetectar
    DiaVencimientoDetectado TINYINT NULL,
    -- Ej: 17 si detectas “día 17 del mes inmediato posterior”.
    FechaInicio DATE NULL,
    FechaFin DATE NULL,
    TextoOriginal NVARCHAR(MAX) NULL,
    ClaveBily VARCHAR(100) NULL,
    ConfianzaMapeo DECIMAL(5,2) NULL,
    EsActiva BIT NOT NULL DEFAULT 1
);

Ej.
Declaración anual de ISR del ejercicio Personas morales.
Entero de retenciones mensuales de ISR por sueldos y salarios.
Declaración de proveedores de IVA.
Pago definitivo mensual de IVA.
Pago provisional mensual de ISR personas morales régimen general.
Entero mensual de retenciones de ISR de ingresos por arrendamiento.
Entero de retención de ISR por servicios profesionales. MENSUAL.
Entero de retenciones de IVA Mensual.

CREATE TABLE EmpresaDocumentosSATConfig
(
	RFC VARCHAR(13) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1, --Nueva config
    DescargarCSF BIT NOT NULL DEFAULT 1,
    FrecuenciaDiasCSF INT NOT NULL DEFAULT 30,
    FechaUltimoIntentoCSF DATETIME2 NULL,
    FechaUltimaCSFExitosa DATETIME2 NULL,
    FechaProximaCSF DATETIME NULL,

    DescargarOpinionCumplimiento BIT NOT NULL DEFAULT 1,
    FrecuenciaDiasOpinion INT NOT NULL DEFAULT 30,
    FechaUltimoIntentoOpinion DATETIME2 NULL,
    FechaUltimaOpinionExitosa DATETIME2 NULL,
    FechaProximaOpinion DATETIME2 NULL,

    DescargarDeclaraciones BIT NOT NULL DEFAULT 0,
    EjercicioInicialDeclaraciones INT NOT NULL DEFAULT Actual -6,
    FechaUltimoIntentoDeclaraciones DATETIME2 NULL,
    FechaUltimaDeclaracionesExitosa DATETIME2 NULL,
    FechaProximaDeclaraciones DATETIME2 NULL,

    FechaCreacion DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaModificacion DATETIME2 NULL
);