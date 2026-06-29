INSERT INTO EmpresaDocumentosSATConfig (
    Rfc,
    Activo,
    Procesando,
    FechaInicioProceso,
    DescargarCSF,
    FrecuenciaDiasCSF,
    FechaUltimoIntentoCSF,
    FechaUltimaCSFExitosa,
    FechaProximaCSF,
    EstatusUltimoIntentoCSF,
    MensajeErrorCSF,
    DescargarOpinionCumplimiento,
    FrecuenciaDiasOpinion,
    FechaUltimoIntentoOpinion,
    FechaUltimaOpinionExitosa,
    FechaProximaOpinion,
    EstatusUltimoIntentoOpinion,
    MensajeErrorOpinion,
    DescargarDeclaraciones,
    EjercicioInicialDeclaraciones,
    FechaUltimoIntentoDeclaraciones,
    FechaUltimaDeclaracionesExitosa,
    FechaProximaDeclaraciones,
    EstatusUltimoIntentoDeclaraciones,
    MensajeErrorDeclaraciones,
    FechaCreacion,
    FechaModificacion
)
VALUES (
    'PFE140312IW8',
    1,      -- Activo
    0,      -- Procesando (candado libre)
    NULL,   -- FechaInicioProceso
    1,      -- DescargarCSF
    30,     -- FrecuenciaDiasCSF (default del módulo)
    NULL,   -- FechaUltimoIntentoCSF
    NULL,   -- FechaUltimaCSFExitosa
    NULL,   -- FechaProximaCSF (NULL = elegible de inmediato, ver ListarRfcsElegibles)
    NULL,   -- EstatusUltimoIntentoCSF
    NULL,   -- MensajeErrorCSF
    0,      -- DescargarOpinionCumplimiento (futuro, no v1)
    30,     -- FrecuenciaDiasOpinion
    NULL, NULL, NULL, NULL, NULL,
    0,      -- DescargarDeclaraciones (futuro, no v1)
    YEAR(GETDATE()) - 6,   -- EjercicioInicialDeclaraciones (ADR-11; aquí vía SQL solo para la prueba)
    NULL, NULL, NULL, NULL, NULL,
    GETDATE(),  -- FechaCreacion (en código real sería Fechas.ObtenerHoraLocal(); aquí GETDATE() solo para el script manual)
    NULL        -- FechaModificacion
);