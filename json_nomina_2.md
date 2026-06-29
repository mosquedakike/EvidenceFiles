# JSON de nómina — Desglose del complemento de Nómina en consulta de CFDI

**Tarea Asana:** https://app.asana.com/1/1113198542081588/project/1204994788487423/task/1215931631358944
**Definición técnica:** Enrique Hernández (Líder Técnico) · **Delegada por:** Andrés Gutiérrez (CTO)

> Borrador para revisión — no se ha modificado la tarjeta en Asana.

---

## Qué se pide

Hoy, al consultar un CFDI tipo **Pago (P)**, la respuesta ya incluye un bloque `pago` con el desglose completo del complemento (totales, pagos, documentos relacionados, impuestos), reflejando uno a uno los nodos del XSD del SAT.

Se pide lo mismo para el complemento de **Nómina**: que la consulta de un CFDI de nómina devuelva un bloque `nomina` con la estructura **completa** del complemento 1.2 del SAT — emisor (con entidad SNCF), receptor (con subcontratación), percepciones (con horas extra, acciones o títulos, jubilación/pensión/retiro y separación/indemnización), deducciones, otros pagos (con subsidio al empleo y compensación de saldos a favor) e incapacidades. No es un resumen ni un subconjunto: es el mismo nivel de detalle que ya existe para `pago`.

Y ese desglose debe verse también en el portal web, como ya existe la pestaña "Desglose pago".

Si el comprobante no es de nómina, `nomina` va en `null` (igual que hoy pasa con `pago`).

---

## Por qué no es trivial

- Pagos ya tiene navegación `Comprobante → Pagos` en el modelo EF, por eso se carga con un simple `Include`. **Nómina no tiene esa relación todavía** — hay que agregarla (mismo patrón 1-1 que ya existe para `PagosTotale`) y su migration correspondiente.
- Los DTOs de entidad de nómina (`NominaPercepcionesDto`, `NominaDeduccionesDto`) hoy solo traen **totales**, no las líneas y nodos de detalle que sí existen en el modelo EF y en el XSD. Hay que enriquecerlos para cubrir todo el complemento.
- Falta crear el DTO de respuesta API (`DTOs\API\Comprobante\Nomina\`), una clase por nodo del XSD, análogo a la carpeta `Pagos\`.
- Falta la pestaña de desglose en el front.

Todo lo demás (tablas, entidades, helpers de datos, negocio de nómina) **ya existe** y ya tiene la misma granularidad del XSD — es reutilizar, no construir desde cero.

---

## Dónde mirar como plantilla (patrón de Pagos)

| Capa | Archivo |
|---|---|
| DTO API | `LinkCFDI.Comun\DTOs\API\Comprobante\Pagos\` |
| Armado de respuesta | `ComprobanteNegocio.MapeaComprobanteDtoAComprobanteAPI` (~línea 462) |
| Carga BD | `ComprobanteDatosHelper` (Includes de Pagos, ~línea 193) |
| Root DTO | `Comprobante.cs` → propiedad `pago` / `pago_specified` |
| Front | `_DetalleComprobante.cshtml` → tab "Desglose pago" |
| Referencia de atributos del XSD | `LinkCFDI.CFDI\Serializacion\Complementos\Nomina12\*.cs` |

---

## Alcance del trabajo

1. **Modelo/Datos:** agregar relación `Comprobante ↔ Nomina` (1-1, vía UUID) + migration; cargar el grafo completo (emisor, receptor, percepciones con sus sub-nodos, deducciones, otros pagos con sus sub-nodos, incapacidades).
2. **DTOs API:** crear una clase por nodo del XSD (snake_case, convenciones de Integradores) y agregar el bloque `nomina` a `Comprobante.cs`.
3. **Negocio:** construir `comprobante.nomina` en el armado de respuesta, recorriendo cada nodo, espejo de `pago`.
4. **Front:** pestaña "Desglose nómina" en el detalle de comprobante.
5. **Pruebas:** nómina con todos los nodos opcionales presentes, nómina solo con los nodos obligatorios, comprobante no-nómina, no regresión sobre Pago e Ingreso.

---

## Decisiones a confirmar antes de iniciar

- ¿La pestaña de front aplica a Comprobantes, Recepciones y Portal, o solo a una en esta fase?
- ¿Se da soporte a nómina 1.1 además de 1.2? (1.1 no tiene EntidadSNCF, AccionesOTitulos ni SubContratacion)
- ¿Aplica también a la API de Usuarios/Web, o solo a Integradores?

---

## Riesgos a vigilar

- El método de armado (`MapeaComprobanteDtoAComprobanteAPI`) es central y lo usan varios manejadores — cuidar no-regresión.
- Cargar el grafo completo de nómina con varios `ThenInclude` puede pesar en performance; medir.
- Respetar multi-tenant al cargar la nómina (empresa/sucursal del solicitante).
- Cada nodo opcional del XSD necesita su propio `_specified` para no romper el contrato cuando el CFDI no lo trae.

---

## Ejemplo del bloque `nomina` (estructura completa conforme al XSD del SAT — Nómina 1.2)

```json
"nomina": {
    "version": "1.2",
    "tipo_nomina": "O",
    "fecha_pago": "2026-06-15",
    "fecha_inicial_pago": "2026-06-01",
    "fecha_final_pago": "2026-06-15",
    "num_dias_pagados": 15.000,
    "total_percepciones": 12000.00,
    "total_deducciones": 2500.00,
    "total_otros_pagos": 300.00,
    "emisor": {
        "curp": null,
        "registro_patronal": "B5510768108",
        "rfc_patron_origen": null,
        "entidad_sncf": {
            "origen_recurso": "IP",
            "monto_recurso_propio": 0.00
        }
    },
    "receptor": {
        "curp": "XXXX000000XXXXXX00",
        "num_seguridad_social": "00000000000",
        "fecha_inicio_rel_laboral": "2020-01-01",
        "antiguedad": "P6Y",
        "tipo_contrato": "01",
        "sindicalizado": "No",
        "tipo_jornada": "01",
        "tipo_regimen": "02",
        "num_empleado": "123",
        "departamento": "Sistemas",
        "puesto": "Desarrollador",
        "riesgo_puesto": "1",
        "periodicidad_pago": "04",
        "banco": "002",
        "cuenta_bancaria": "012180000123456789",
        "salario_base_cot_apor": 500.00,
        "salario_diario_integrado": 550.00,
        "clave_ent_fed": "MEX",
        "subcontratacion": [
            { "rfc_labora": "EKU9003173C9", "porcentaje_tiempo": 50.00 }
        ]
    },
    "percepciones": {
        "total_sueldos": 11000.00,
        "total_separacion_indemnizacion": 0.00,
        "total_jubilacion_pension_retiro": 0.00,
        "total_gravado": 11000.00,
        "total_exento": 1000.00,
        "detalle": [
            {
                "tipo_percepcion": "001",
                "clave": "001",
                "concepto": "Sueldos, salarios rayas y jornales",
                "importe_gravado": 11000.00,
                "importe_exento": 1000.00,
                "acciones_o_titulos": { "valor_mercado": 0.00, "precio_al_otorgarse": 0.00 },
                "horas_extra": [
                    { "dias": 1, "tipo_horas": "01", "horas_extra": 2, "importe_pagado": 150.00 }
                ]
            }
        ],
        "jubilacion_pension_retiro": {
            "total_una_exhibicion": 0.00,
            "total_parcialidad": 0.00,
            "monto_diario": 0.00,
            "ingreso_acumulable": 0.00,
            "ingreso_no_acumulable": 0.00
        },
        "separacion_indemnizacion": {
            "total_pagado": 0.00,
            "ingreso_acumulable": 0.00,
            "ingreso_no_acumulable": 0.00,
            "num_anios_servicio": 0,
            "ultimo_sueldo_mens_ord": 0.00
        }
    },
    "deducciones": {
        "total_otras_deducciones": 500.00,
        "total_impuestos_retenidos": 2000.00,
        "detalle": [
            { "tipo_deduccion": "002", "clave": "002", "concepto": "ISR", "importe": 2000.00 }
        ]
    },
    "otros_pagos": [
        {
            "tipo_otro_pago": "002",
            "clave": "002",
            "concepto": "Subsidio para el empleo",
            "importe": 300.00,
            "subsidio_al_empleo": { "subsidio_causado": 300.00 },
            "compensacion_saldos_a_favor": null
        }
    ],
    "incapacidades": [
        { "dias_incapacidad": 0, "tipo_incapacidad": "01", "importe_monetario": null }
    ]
}
```

> Los nodos `entidad_sncf`, `subcontratacion`, `acciones_o_titulos`, `horas_extra`, `jubilacion_pension_retiro`, `separacion_indemnizacion`, `subsidio_al_empleo` y `compensacion_saldos_a_favor` son opcionales en el XSD: se omiten cuando el CFDI no los trae, igual que ya pasa con los atributos opcionales de `pago`.

---

> Pendiente: confirmar las decisiones de alcance antes de pasar la tarjeta a "Definida" y asignarla a desarrollo.
