/* ============================================================
   PRY2204 - MODELAMIENTO DE BASES DE DATOS
   SEMANA 6

   IMPLEMENTANDO UN MODELO RELACIONAL CON SENTENCIAS SQL

   CASO:
   CONSULTORIO MEDICO MUNICIPALIDAD SANTA GEMA
   ============================================================ */


/* ============================================================
   CASO 1
   ============================================================ */


/* ============================================================
   PASO 0 - BORRADO DE OBJETOS

   Extracto del caso:
   "Para asegurar una correcta implementacion, deberas incluir
   al inicio del script DDL, las instrucciones de borrado de
   objetos a construir."

   Las tablas se eliminan antes de volver a crearlas.
   ============================================================ */

DROP TABLE DOSIS CASCADE CONSTRAINTS;
DROP TABLE PAGO CASCADE CONSTRAINTS;
DROP TABLE RECETA CASCADE CONSTRAINTS;
DROP TABLE MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE TIPO_MEDICAMENTO CASCADE CONSTRAINTS;
DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;
DROP TABLE MEDICO CASCADE CONSTRAINTS;
DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;
DROP TABLE DIGITADOR CASCADE CONSTRAINTS;
DROP TABLE PACIENTE CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE BANCO CASCADE CONSTRAINTS;


/* ============================================================
   PASO 1 - CREACION DE TABLAS
   ============================================================ */


/* ------------------------------------------------------------
   TABLA TIPO_MEDICAMENTO

   Permite clasificar los medicamentos segun su tipo.
   ------------------------------------------------------------ */

CREATE TABLE TIPO_MEDICAMENTO
(
    ID_TIPO_MEDICAMENTO NUMBER(3)    NOT NULL,
    DESCRIPCION         VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA MEDICAMENTO

   Extracto del caso:
   "Los medicamentos deben tener un identificador unico."
   "Los medicamentos deben tener un nombre, una dosis
   recomendada y un stock disponible para la venta."
   "Los medicamentos pueden ser de diferentes tipos."

   PRECIO_UNIDAD se agregara posteriormente en el Caso 2.
   ------------------------------------------------------------ */

CREATE TABLE MEDICAMENTO
(
    COD_MEDICAMENTO     NUMBER(7)
        GENERATED ALWAYS AS IDENTITY,
    NOMBRE              VARCHAR2(25) NOT NULL,
    STOCK_DISPONIBLE    NUMBER(5) DEFAULT 0 NOT NULL,
    ID_TIPO_MEDICAMENTO NUMBER(3) NOT NULL
);


/* ------------------------------------------------------------
   TABLA COMUNA

   Extracto del caso:
   "El identificador de la tabla COMUNA es un numero que
   comienza en 1101 y que se incrementa en 1."
   ------------------------------------------------------------ */

CREATE TABLE COMUNA
(
    ID_COMUNA NUMBER(6)
        GENERATED ALWAYS AS IDENTITY
        (START WITH 1101 INCREMENT BY 1),
    NOMBRE VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA PACIENTE

   El modelo inicial contiene EDAD.
   En el Caso 2 sera reemplazada por FECHA_NACIMIENTO.

   Se mantiene la informacion solicitada para domicilio:
   comuna, ciudad y region.
   ------------------------------------------------------------ */

CREATE TABLE PACIENTE
(
    RUT_PAC    VARCHAR2(25) NOT NULL,
    DV_PAC     CHAR(1)      NOT NULL,
    PNOMBRE    VARCHAR2(25) NOT NULL,
    SNOMBRE    VARCHAR2(25),
    EDAD       DATE,
    TELEFONO   NUMBER(11),
    CALLE      VARCHAR2(25),
    NUMERACION NUMBER(6),
    ID_COMUNA  NUMBER(6)    NOT NULL,
    CIUDAD     NUMBER(6),
    REGION     NUMBER(6)
);


/* ------------------------------------------------------------
   TABLA ESPECIALIDAD

   Extracto del caso:
   "El identificador numerico de la tabla ESPECIALIDAD
   se debe incrementar automaticamente."
   ------------------------------------------------------------ */

CREATE TABLE ESPECIALIDAD
(
    ID_ESPECIALIDAD NUMBER(3)
        GENERATED ALWAYS AS IDENTITY,
    NOMBRE VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA MEDICO
   ------------------------------------------------------------ */

CREATE TABLE MEDICO
(
    RUT_MED         NUMBER(8)    NOT NULL,
    DV_MED          CHAR(1)      NOT NULL,
    PNOMBRE         VARCHAR2(25) NOT NULL,
    SNOMBRE         VARCHAR2(25),
    PAPELLIDO       VARCHAR2(25) NOT NULL,
    SAPELLIDO       VARCHAR2(25),
    TELEFONO        NUMBER(11)   NOT NULL,
    ID_ESPECIALIDAD NUMBER(3)    NOT NULL
);


/* ------------------------------------------------------------
   TABLA DIGITADOR

   Las recetas son ingresadas al sistema por un digitador.
   ------------------------------------------------------------ */

CREATE TABLE DIGITADOR
(
    ID_DIGITADOR NUMBER(8)    NOT NULL,
    DV_DIGITADOR CHAR(1)      NOT NULL,
    NOMBRE       VARCHAR2(25) NOT NULL,
    APELLIDO     VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA DIAGNOSTICO

   Cada receta posee un diagnostico.
   ------------------------------------------------------------ */

CREATE TABLE DIAGNOSTICO
(
    COD_DIAGNOSTICO NUMBER(8)    NOT NULL,
    NOMBRE          VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA RECETA

   Cada receta se relaciona con:
   - un paciente
   - un medico
   - un digitador
   - un diagnostico
   ------------------------------------------------------------ */

CREATE TABLE RECETA
(
    COD_RECETA        NUMBER(7)     NOT NULL,
    OBSERVACIONES     VARCHAR2(500),
    FECHA_EMISION     NUMBER(6),
    FECHA_VENCIMIENTO VARCHAR2(25),
    TIPO_RECETA       VARCHAR2(25)  NOT NULL,
    ID_DIGITADOR      NUMBER(8)     NOT NULL,
    COD_DIAGNOSTICO   NUMBER(8)     NOT NULL,
    RUT_MED           NUMBER(8)     NOT NULL,
    RUT_PAC           VARCHAR2(25)  NOT NULL
);


/* ------------------------------------------------------------
   TABLA DOSIS

   Resuelve la asociacion entre RECETA y MEDICAMENTO.
   Una receta puede contener uno o mas medicamentos.
   ------------------------------------------------------------ */

CREATE TABLE DOSIS
(
    COD_MEDICAMENTO   NUMBER(7)    NOT NULL,
    COD_RECETA        NUMBER(7)    NOT NULL,
    DESCRIPCION_DOSIS VARCHAR2(25) NOT NULL
);


/* ------------------------------------------------------------
   TABLA BANCO
   ------------------------------------------------------------ */

CREATE TABLE BANCO
(
    COD_BANCO NUMBER(2)    NOT NULL,
    NOMBRE    VARCHAR2(30) NOT NULL
);


/* ------------------------------------------------------------
   TABLA PAGO

   Extracto del caso:
   "Una receta puede tener asociado uno o mas pagos,
   y cada pago debe estar asociado a una receta
   medica especifica."
   ------------------------------------------------------------ */

CREATE TABLE PAGO
(
    COD_PAGO    NUMBER(8)    NOT NULL,
    COD_RECETA  NUMBER(7)    NOT NULL,
    FECHA_PAGO  DATE         NOT NULL,
    MONTO_TOTAL NUMBER(12)   NOT NULL,
    METODO_PAGO VARCHAR2(25),
    ID_BANCO    NUMBER(2)
);


/* ============================================================
   PASO 2 - RESTRICCIONES DEL MODELO
   PRIMARY KEY, FOREIGN KEY, UNIQUE Y CHECK
   ============================================================ */


/* ------------------------------------------------------------
   PRIMARY KEY
   ------------------------------------------------------------ */

ALTER TABLE TIPO_MEDICAMENTO
ADD CONSTRAINT TIPO_MEDICAMENTO_PK
PRIMARY KEY (ID_TIPO_MEDICAMENTO);


ALTER TABLE MEDICAMENTO
ADD CONSTRAINT MEDICAMENTO_PK
PRIMARY KEY (COD_MEDICAMENTO);


ALTER TABLE COMUNA
ADD CONSTRAINT COMUNA_PK
PRIMARY KEY (ID_COMUNA);


ALTER TABLE PACIENTE
ADD CONSTRAINT PACIENTE_PK
PRIMARY KEY (RUT_PAC);


ALTER TABLE ESPECIALIDAD
ADD CONSTRAINT ESPECIALIDAD_PK
PRIMARY KEY (ID_ESPECIALIDAD);


ALTER TABLE MEDICO
ADD CONSTRAINT MEDICO_PK
PRIMARY KEY (RUT_MED);


ALTER TABLE DIGITADOR
ADD CONSTRAINT DIGITADOR_PK
PRIMARY KEY (ID_DIGITADOR);


ALTER TABLE DIAGNOSTICO
ADD CONSTRAINT DIAGNOSTICO_PK
PRIMARY KEY (COD_DIAGNOSTICO);


ALTER TABLE RECETA
ADD CONSTRAINT RECETA_PK
PRIMARY KEY (COD_RECETA);


ALTER TABLE DOSIS
ADD CONSTRAINT DOSIS_PK
PRIMARY KEY (COD_MEDICAMENTO, COD_RECETA);


ALTER TABLE BANCO
ADD CONSTRAINT BANCO_PK
PRIMARY KEY (COD_BANCO);


ALTER TABLE PAGO
ADD CONSTRAINT PAGO_PK
PRIMARY KEY (COD_PAGO);


/* ------------------------------------------------------------
   FOREIGN KEY
   ------------------------------------------------------------ */

ALTER TABLE MEDICAMENTO
ADD CONSTRAINT MEDICAMENTO_TIPO_FK
FOREIGN KEY (ID_TIPO_MEDICAMENTO)
REFERENCES TIPO_MEDICAMENTO(ID_TIPO_MEDICAMENTO);


ALTER TABLE PACIENTE
ADD CONSTRAINT PACIENTE_COMUNA_FK
FOREIGN KEY (ID_COMUNA)
REFERENCES COMUNA(ID_COMUNA);


ALTER TABLE MEDICO
ADD CONSTRAINT MEDICO_ESPECIALIDAD_FK
FOREIGN KEY (ID_ESPECIALIDAD)
REFERENCES ESPECIALIDAD(ID_ESPECIALIDAD);


ALTER TABLE RECETA
ADD CONSTRAINT RECETA_DIGITADOR_FK
FOREIGN KEY (ID_DIGITADOR)
REFERENCES DIGITADOR(ID_DIGITADOR);


ALTER TABLE RECETA
ADD CONSTRAINT RECETA_DIAGNOSTICO_FK
FOREIGN KEY (COD_DIAGNOSTICO)
REFERENCES DIAGNOSTICO(COD_DIAGNOSTICO);


ALTER TABLE RECETA
ADD CONSTRAINT RECETA_MEDICO_FK
FOREIGN KEY (RUT_MED)
REFERENCES MEDICO(RUT_MED);


ALTER TABLE RECETA
ADD CONSTRAINT RECETA_PACIENTE_FK
FOREIGN KEY (RUT_PAC)
REFERENCES PACIENTE(RUT_PAC);


ALTER TABLE DOSIS
ADD CONSTRAINT DOSIS_MEDICAMENTO_FK
FOREIGN KEY (COD_MEDICAMENTO)
REFERENCES MEDICAMENTO(COD_MEDICAMENTO);


ALTER TABLE DOSIS
ADD CONSTRAINT DOSIS_RECETA_FK
FOREIGN KEY (COD_RECETA)
REFERENCES RECETA(COD_RECETA);


ALTER TABLE PAGO
ADD CONSTRAINT PAGO_RECETA_FK
FOREIGN KEY (COD_RECETA)
REFERENCES RECETA(COD_RECETA);


ALTER TABLE PAGO
ADD CONSTRAINT PAGO_BANCO_FK
FOREIGN KEY (ID_BANCO)
REFERENCES BANCO(COD_BANCO);


/* ------------------------------------------------------------
   UNIQUE

   Extracto del caso:
   "Los medicos deben tener un telefono localizable.
   Este numero telefonico debe ser unico en la base de datos."
   ------------------------------------------------------------ */

ALTER TABLE MEDICO
ADD CONSTRAINT MEDICO_TELEFONO_UN
UNIQUE (TELEFONO);


/* ------------------------------------------------------------
   CHECK - DIGITOS VERIFICADORES

   Extracto del caso:
   "El digito verificador de los pacientes, medicos y
   digitadores solo deben permitir los valores 0 al 9
   y la letra K."
   ------------------------------------------------------------ */

ALTER TABLE PACIENTE
ADD CONSTRAINT PACIENTE_DV_CK
CHECK
(
    DV_PAC IN
    ('0','1','2','3','4','5','6','7','8','9','K')
);


ALTER TABLE MEDICO
ADD CONSTRAINT MEDICO_DV_CK
CHECK
(
    DV_MED IN
    ('0','1','2','3','4','5','6','7','8','9','K')
);


ALTER TABLE DIGITADOR
ADD CONSTRAINT DIGITADOR_DV_CK
CHECK
(
    DV_DIGITADOR IN
    ('0','1','2','3','4','5','6','7','8','9','K')
);


/* ------------------------------------------------------------
   CHECK - TIPO DE RECETA

   Tipos permitidos:
   DIGITAL, MAGISTRAL, RETENIDA, GENERAL, VETERINARIA.
   ------------------------------------------------------------ */

ALTER TABLE RECETA
ADD CONSTRAINT RECETA_TIPO_CK
CHECK
(
    TIPO_RECETA IN
    (
        'DIGITAL',
        'MAGISTRAL',
        'RETENIDA',
        'GENERAL',
        'VETERINARIA'
    )
);


/* ============================================================
   CASO 2
   ACCIONES POSTERIORES AL CASO 1
   ============================================================ */


/* ------------------------------------------------------------
   PRECIO UNITARIO DEL MEDICAMENTO

   Extracto del Caso 2:
   "Agregar el precio unitario de cada medicamento."

   En el ejemplo de clase se utiliza NUMBER(7),
   DEFAULT 1000 y NOT NULL.
   ------------------------------------------------------------ */

ALTER TABLE MEDICAMENTO
ADD PRECIO_UNIDAD NUMBER(7) DEFAULT 1000 NOT NULL;


/* ------------------------------------------------------------
   CHECK PRECIO MEDICAMENTO

   Extracto del Caso 2:
   "Se conoce que el precio de un medicamento oscila entre
   los $1.000 y los $2.000.000 de pesos."
   ------------------------------------------------------------ */

ALTER TABLE MEDICAMENTO
ADD CONSTRAINT MEDICAMENTO_PRECIO_CK
CHECK (PRECIO_UNIDAD BETWEEN 1000 AND 2000000);


/* ------------------------------------------------------------
   CHECK METODO DE PAGO

   Extracto del Caso 2:
   "Los metodos de pagos pueden ser:
   EFECTIVO, TARJETA, TRANSFERENCIA."
   ------------------------------------------------------------ */

ALTER TABLE PAGO
ADD CONSTRAINT PAGO_METODO_CK
CHECK
(
    METODO_PAGO IN
    (
        'EFECTIVO',
        'TARJETA',
        'TRANSFERENCIA'
    )
);


/* ------------------------------------------------------------
   MODIFICACION DE PACIENTE

   Extracto del Caso 2:
   "Se debe eliminar la columna edad, y en su reemplazo
   agregar la fecha de nacimiento del paciente."
   ------------------------------------------------------------ */

ALTER TABLE PACIENTE
DROP COLUMN EDAD;


ALTER TABLE PACIENTE
ADD FECHA_NACIMIENTO DATE;


/* ============================================================
   FIN DEL SCRIPT
   ============================================================ */