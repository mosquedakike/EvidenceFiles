Para cada endpoint: (No copiar y pegar)

Agregar parámetros (usar triple diagonal para generarlos automáticamente)
ej. 
///<param name="request">Solicitud para crear una nueva empresa</param>... etc... etc...

ej 2. 
///<param name="X_Token_Emp">El token identificador de la empresa</param>
<param name="fechaInicial">La fecha final para la búsqueda de descargas que cubran el rango</param>
<param name="pagina">La página que se desea listar</param>

Agregar título de la función
ej. 
///<summary>Crear empresa</summary>
Mantener la misma nomenclatura que los demás controladores, Crear {objeto}, Editar {objeto}, Obtener, Listar, Habilitar, Deshabilitar...

Agregar descripción breve
ej. 
///<remarks>Crea una nueva empresa para su administración</remarks>

Agregar posibles códigos de respuesta (casi igual para todos a menos que haya casos especiales como timbradoException)
ej. 
/// <response code="200">Solicitud exitosa (OK)</response>
/// <response code="400">Solicitud inválida (Bad Request)</response>
/// <response code="401">Sin autorización (Unauthorized)</response>
/// <response code="403">Prohibido (Forbidden)</response>
/// <response code="404">No encontrado (Not found)</response>
/// <response code="409">Conflicto (Conflict)</response>
/// <response code="422">Solicitud no procesable (Unprocessable Content)</response>
/// <response code="500">Error (Internal Server Error)</response>

Agregar [Produces("application/json")] (aplica para casi todos a excepción de los pdf, csv...)

Agregar posibles ejemplos de respuesta (casi igual para todos a excepción del código 200)
ej. 
[SwaggerRequestExample(typeof(Empresa), typeof(EjemploCrearEmpresaRequest))]

[ProducesResponseType(typeof(Empresa), StatusCodes.Status200OK)]
[SwaggerResponseExample(StatusCodes.Status200OK, typeof(EjemploCrearEmpresaResponse))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status400BadRequest)]
[SwaggerResponseExample(StatusCodes.Status400BadRequest, typeof(EjemploBadRequestGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status401Unauthorized)]
[SwaggerResponseExample(StatusCodes.Status401Unauthorized, typeof(EjemploUnauthorizedGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status403Forbidden)]
[SwaggerResponseExample(StatusCodes.Status403Forbidden, typeof(EjemploForbiddenGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status404NotFound)]
[SwaggerResponseExample(StatusCodes.Status404NotFound, typeof(EjemploNotFoundGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status409Conflict)]
[SwaggerResponseExample(StatusCodes.Status409Conflict, typeof(EjemploConflictGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status422UnprocessableEntity)]
[SwaggerResponseExample(StatusCodes.Status422UnprocessableEntity, typeof(EjemploNoProcesableGenerico))]

[ProducesResponseType(typeof(ExceptionResponse), StatusCodes.Status500InternalServerError)]
[SwaggerResponseExample(StatusCodes.Status500InternalServerError, typeof(EjemploServerErrorGenerico))]

Nota I: Los endpoints donde no hay body y son solo parámetros de query no es necesario documentar ejemplo de request.

Nota II: Podemos omitir el ejemplo del response 200, siempre y cuando se cumpla la siguiente condición para la prueba (Try it)

"El developer puede seleccionar el ejemplo del request, ingresar apikey y tokens (sucursal/empresa o recurso), hacer clic en Try it y el servicio contesta correctamente con datos (200)"

Nota III: Para los ejemplos de request y response código 200 (exito) se deberán generar las clase de ejemplo bajo LinkCFDI.API.Ejemplos.{Entidad} e implementar GetExamples con IExamplesProvider<T>, en caso de ser aplicable deberá hacer override de los atributos que no apliquen al request para poder omitirlos (agregar propiedad X_specified).
ej.
/// <summary>
/// Indica si la empresa se encuentra activa para hacer uso del sistema
/// </summary>
[JsonPropertyName("activa")]
public bool activa { get; set; }
[SwaggerIgnore]
public bool activa_specified { get; set; } = true;

Nota IV: Para que las propiedades _specified funcionen correctamente (es decir, que los campos con _specified = false sean omitidos del JSON serializado), el DTO debe tener el atributo [JsonConverter(typeof(ConditionalPropertyConverter<T>))] a nivel de clase. Sin este atributo, los campos internos (como rfc_empresa, id_sucursal) seguirán apareciendo en el ejemplo de Swagger aunque su _specified sea false.
ej.
[JsonConverter(typeof(ConditionalPropertyConverter<MiRequest>))]
public class MiRequest
{
    [JsonPropertyName("rfc_empresa")]
    public string? rfc_empresa { get; set; }
    [SwaggerIgnore]
    public bool rfc_empresa_specified { get; set; } = true;
}
El converter está declarado globalmente (sin namespace), por lo que no requiere using adicional.
Se debe aplicar en conjunto con [SwaggerHideRequestProperties(...)] en el endpoint del controlador para ocultar los campos del schema de Swagger:
ej.
[SwaggerHideRequestProperties("rfc_empresa", "id_sucursal")]
Los nombres que se pasan a SwaggerHideRequestProperties deben coincidir exactamente con el valor del [JsonPropertyName(...)] de cada propiedad.

Ocultar atributos no aplicables del objeto (Request) original
ej.
[SwaggerHideRequestProperties("token","objeto","activa","fiel","sucursales","sincronizacion")]

Verificar nomenclatura y orden de los atributos de los Request y Response
Todos los atributos deberán tener su especificación [JsonPropertyName("su_nombre")]
La nomenclatura será siempre minúsculas, las palabras compuestas se separan por un guión bajo
Acomodar en orden alfabético (si hay token y objeto esos van primero)
ej. [JsonPropertyName("cadena_original")]
public string? cadena_original { get; set; }

Agregar descripción a los atributos del Request y del Response
ej. 
// <summary>
/// El número de serie del certificado de sello digital del SAT
/// </summary>
[StringLength(20, MinimumLength = 20)]
[JsonPropertyName("no_certificado_sat")]
public string? no_certificado_sat { get; set; }

Actualizar documentación ReadMe (Solicitar a Andrés) y Postman (Import desde swagger)

Url publica de la especificación: https://sandbox-api.bily.mx/swagger/v1/swagger.json

Readme: Revisar título, descripción, Body Params (deberá mostrar solo los atributos aplicables con su descripción), Responses (deberá mostrar los ejemplos documentados el 200 es el más importante de revisar), Examples (deberá mostrar y llenar el request de ejemplo, deberá mostrar los diferentes ejemplos de respuesta con error)

Postman: Revisar controlador con sus ejemplos (eliminar ejemplos de respuestas de error), el import settings deberá ser Naming requests = Fallback, Set indent character = Space, Folder organization = Tags, Include auth info in example requests = Deshabilitado, Enable optional parameters = Habilitado, Keep implicit headers = Deshabilitado, Include deprecated properties = Deshabilitado, Always inherit authentication = Habilitado

Pruebas
Readme: probar Try it (deberá ejecutarse correctamente)

Postman: probar ejemplo

Probar autenticación sin bearer token, no debería permitir (Unauthorized)
Probar autenticación con otro bearer token, no debería permitir (Unauthorized)
Probar autorización sobre el recurso, un token que no sea propio de la sucursal (Not found)
Probar con un request incompleto o datos inconsistentes (Bad request)
Probar ejemplo OK (200) (deberá ejecutarse correctamente)

Revisar consistencia en atributos de los responses (sin atributos privados (ej, IdSucursal, FechaModificación, IdRelación..., Órden alfabético en su mayoría, minúsculas, palabras-separadas-por-guion, sin acentos)

Una vez aprobado se deberá pasar el endpoint a la colección correspondiente, borrar llaves dejar petición limpia (Revisar con Andrés)

Nota; Configurar environment con variables X-Token-Suc, X-Token-Emp y bearerToken, la colección ya debe contener las variables baseUrl y version de forma automática después del import