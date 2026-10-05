/* ============================================================
   PRY2204 - MODELAMIENTO DE BASES DE DATOS
   EXPERIENCIA 3 - SEMANA 8

   TALLER MECANICO MIKES LTDA.

   Construccion de una Base de Datos a partir de un
   Modelo Relacional Normalizado con sentencias SQL
   ============================================================ */


/* ============================================================
   CASO 1: IMPLEMENTACION DEL MODELO
   ============================================================ */


/* ============================================================
   PASO 0: LIMPIEZA CONTROLADA DE OBJETOS
   ============================================================ */

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE DETALLE_SERVICIO CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE MANTENCION CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE MECANICO CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE AUTOMOVIL CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE PREMIUM CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE ESTANDAR CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE CLIENTE CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE MODELO CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE MARCA CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE TIPO_AUTOMOVIL CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE SERVICIO CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE SUCURSAL CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE CIUDAD CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'DROP TABLE PAIS CASCADE CONSTRAINTS PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/


/* ============================================================
   LIMPIEZA CONTROLADA DE SECUENCIAS
   ============================================================ */

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_SERVICIO';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_CIUDAD';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2289 THEN
            RAISE;
        END IF;
END;
/


/* ============================================================
   PASO 1: CREACION DE TABLAS
   ============================================================ */


/* ============================================================
   TABLA PAIS
   IDENTITY: inicia en 9 e incrementa en 3
   ============================================================ */

CREATE TABLE PAIS (
    id_pais NUMBER(3)
        GENERATED ALWAYS AS IDENTITY
        (START WITH 9 INCREMENT BY 3),
    nom_pais VARCHAR2(30) NOT NULL
);

ALTER TABLE PAIS
    ADD CONSTRAINT PAIS_PK
    PRIMARY KEY (id_pais);


/* ============================================================
   TABLA CIUDAD
   ============================================================ */

CREATE TABLE CIUDAD (
    id_ciudad  NUMBER(5) NOT NULL,
    nom_ciudad VARCHAR2(30) NOT NULL,
    cod_pais   NUMBER(3) NOT NULL
);

ALTER TABLE CIUDAD
    ADD CONSTRAINT CIUDAD_PK
    PRIMARY KEY (id_ciudad);

ALTER TABLE CIUDAD
    ADD CONSTRAINT CIUDAD_FK_PAIS
    FOREIGN KEY (cod_pais)
    REFERENCES PAIS (id_pais);


/* ============================================================
   TABLA SUCURSAL
   ============================================================ */

CREATE TABLE SUCURSAL (
    id_sucursal  CHAR(3) NOT NULL,
    nom_sucursal VARCHAR2(30) NOT NULL,
    calle        VARCHAR2(20) NOT NULL,
    num_calle    NUMBER(4) NOT NULL,
    cod_ciudad   NUMBER(5) NOT NULL
);

ALTER TABLE SUCURSAL
    ADD CONSTRAINT SUCURSAL_PK
    PRIMARY KEY (id_sucursal);

ALTER TABLE SUCURSAL
    ADD CONSTRAINT SUCURSAL_FK_CIUDAD
    FOREIGN KEY (cod_ciudad)
    REFERENCES CIUDAD (id_ciudad);


/* ============================================================
   TABLA SERVICIO
   ============================================================ */

CREATE TABLE SERVICIO (
    id_servicio NUMBER(3) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL,
    costo       NUMBER(7) NOT NULL
);

ALTER TABLE SERVICIO
    ADD CONSTRAINT SERVICIO_PK
    PRIMARY KEY (id_servicio);


/* ============================================================
   TABLA MARCA
   ============================================================ */

CREATE TABLE MARCA (
    id_marca    NUMBER(2) NOT NULL,
    descripcion VARCHAR2(20) NOT NULL
);

ALTER TABLE MARCA
    ADD CONSTRAINT MARCA_PK
    PRIMARY KEY (id_marca);


/* ============================================================
   TABLA MODELO
   ============================================================ */

CREATE TABLE MODELO (
    id_modelo   NUMBER(3) NOT NULL,
    marca_id    NUMBER(2) NOT NULL,
    descripcion VARCHAR2(30) NOT NULL
);

ALTER TABLE MODELO
    ADD CONSTRAINT MODELO_PK
    PRIMARY KEY (
        id_modelo,
        marca_id
    );

ALTER TABLE MODELO
    ADD CONSTRAINT MODELO_FK_MARCA
    FOREIGN KEY (marca_id)
    REFERENCES MARCA (id_marca);


/* ============================================================
   TABLA TIPO_AUTOMOVIL
   ============================================================ */

CREATE TABLE TIPO_AUTOMOVIL (
    id_tipo     CHAR(2) NOT NULL,
    descripcion VARCHAR2(25) NOT NULL
);

ALTER TABLE TIPO_AUTOMOVIL
    ADD CONSTRAINT TIPO_AUTOMOVIL_PK
    PRIMARY KEY (id_tipo);


/* ============================================================
   TABLA CLIENTE
   ============================================================ */

CREATE TABLE CLIENTE (
    rut       NUMBER(8) NOT NULL,
    dv        CHAR(1) NOT NULL,
    pnombre   VARCHAR2(25) NOT NULL,
    snombre   VARCHAR2(25),
    apaterno  VARCHAR2(25) NOT NULL,
    amaterno  VARCHAR2(25) NOT NULL,
    telefono  VARCHAR2(15),
    email     VARCHAR2(50),
    tipo_cli  CHAR(1) NOT NULL
);

ALTER TABLE CLIENTE
    ADD CONSTRAINT CLIENTE_PK
    PRIMARY KEY (rut);


/* ============================================================
   TABLA ESTANDAR
   Subtipo de CLIENTE
   ============================================================ */

CREATE TABLE ESTANDAR (
    cli_rut           NUMBER(8) NOT NULL,
    puntaje_fidelidad NUMBER(10) NOT NULL
);

ALTER TABLE ESTANDAR
    ADD CONSTRAINT ESTANDAR_PK
    PRIMARY KEY (cli_rut);

ALTER TABLE ESTANDAR
    ADD CONSTRAINT ESTANDAR_FK_CLIENTE
    FOREIGN KEY (cli_rut)
    REFERENCES CLIENTE (rut);


/* ============================================================
   TABLA PREMIUM
   Subtipo de CLIENTE
   ============================================================ */

CREATE TABLE PREMIUM (
    cli_rut       NUMBER(8) NOT NULL,
    monto_cheques NUMBER(10) NOT NULL,
    monto_credito NUMBER(10) NOT NULL
);

ALTER TABLE PREMIUM
    ADD CONSTRAINT PREMIUM_PK
    PRIMARY KEY (cli_rut);

ALTER TABLE PREMIUM
    ADD CONSTRAINT PREMIUM_FK_CLIENTE
    FOREIGN KEY (cli_rut)
    REFERENCES CLIENTE (rut);


/* ============================================================
   TABLA AUTOMOVIL
   ============================================================ */

CREATE TABLE AUTOMOVIL (
    patente       CHAR(6) NOT NULL,
    anno          NUMBER(4) NOT NULL,
    cant_puertas  NUMBER(1) NOT NULL,
    km            NUMBER(8) NOT NULL,
    color         VARCHAR2(30) NOT NULL,
    cod_tipo_auto CHAR(2) NOT NULL,
    cod_modelo    NUMBER(3) NOT NULL,
    cod_marca     NUMBER(2) NOT NULL,
    cli_rut       NUMBER(8) NOT NULL
);

ALTER TABLE AUTOMOVIL
    ADD CONSTRAINT AUTOMOVIL_PK
    PRIMARY KEY (patente);

ALTER TABLE AUTOMOVIL
    ADD CONSTRAINT AUTOMOVIL_FK_CLIENTE
    FOREIGN KEY (cli_rut)
    REFERENCES CLIENTE (rut);

ALTER TABLE AUTOMOVIL
    ADD CONSTRAINT AUTOMOVIL_FK_MODELO
    FOREIGN KEY (cod_modelo, cod_marca)
    REFERENCES MODELO (id_modelo, marca_id);

ALTER TABLE AUTOMOVIL
    ADD CONSTRAINT AUTOMOVIL_FK_TIPO
    FOREIGN KEY (cod_tipo_auto)
    REFERENCES TIPO_AUTOMOVIL (id_tipo);


/* ============================================================
   TABLA MECANICO
   IDENTITY: inicia en 460 e incrementa en 7
   ============================================================ */

CREATE TABLE MECANICO (
    cod_mecanico NUMBER(3)
        GENERATED ALWAYS AS IDENTITY
        (START WITH 460 INCREMENT BY 7),

    pnombre         VARCHAR2(25) NOT NULL,
    snombre         VARCHAR2(25),
    apaterno        VARCHAR2(25) NOT NULL,
    amaterno        VARCHAR2(25) NOT NULL,
    bono_jefatura   NUMBER(10),
    sueldo          NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor  NUMBER(3)
);

ALTER TABLE MECANICO
    ADD CONSTRAINT MECANICO_PK
    PRIMARY KEY (cod_mecanico);

ALTER TABLE MECANICO
    ADD CONSTRAINT MECANICO_FK_SUPERVISOR
    FOREIGN KEY (cod_supervisor)
    REFERENCES MECANICO (cod_mecanico);


/* ============================================================
   TABLA MANTENCION

   En Caso 1 la PK corresponde inicialmente solamente
   a num_mantencion.

   En Caso 2 se modificara mediante ALTER TABLE.
   ============================================================ */

CREATE TABLE MANTENCION (
    num_mantencion NUMBER(4) NOT NULL,
    cod_sucursal   CHAR(3) NOT NULL,
    fecha_ingreso  DATE NOT NULL,
    fecha_salida   DATE,
    patente_auto   CHAR(6),
    cod_mecanico   NUMBER(3) NOT NULL,
    costo_total    NUMBER(10),
    estado         VARCHAR2(15) NOT NULL
);

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_PK
    PRIMARY KEY (num_mantencion);

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_FK_SUCURSAL
    FOREIGN KEY (cod_sucursal)
    REFERENCES SUCURSAL (id_sucursal);

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_FK_AUTOMOVIL
    FOREIGN KEY (patente_auto)
    REFERENCES AUTOMOVIL (patente);

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_FK_MECANICO
    FOREIGN KEY (cod_mecanico)
    REFERENCES MECANICO (cod_mecanico);


/* ============================================================
   TABLA DETALLE_SERVICIO
   ============================================================ */

CREATE TABLE DETALLE_SERVICIO (
    mantencion_num NUMBER(4) NOT NULL,
    cod_servicio   NUMBER(3) NOT NULL,
    descuento_serv NUMBER(4,2),
    cantidad       NUMBER(3) NOT NULL
);

ALTER TABLE DETALLE_SERVICIO
    ADD CONSTRAINT DETALLE_SERVICIO_PK
    PRIMARY KEY (
        mantencion_num,
        cod_servicio
    );

ALTER TABLE DETALLE_SERVICIO
    ADD CONSTRAINT DETALLE_SERVICIO_FK_MANT
    FOREIGN KEY (mantencion_num)
    REFERENCES MANTENCION (num_mantencion);

ALTER TABLE DETALLE_SERVICIO
    ADD CONSTRAINT DETALLE_SERVICIO_FK_SERV
    FOREIGN KEY (cod_servicio)
    REFERENCES SERVICIO (id_servicio);


/* ============================================================
   VERIFICACION DEL CASO 1
   ============================================================ */

SELECT table_name
FROM user_tables
WHERE table_name IN (
    'PAIS',
    'CIUDAD',
    'SUCURSAL',
    'SERVICIO',
    'MARCA',
    'MODELO',
    'TIPO_AUTOMOVIL',
    'CLIENTE',
    'ESTANDAR',
    'PREMIUM',
    'AUTOMOVIL',
    'MECANICO',
    'MANTENCION',
    'DETALLE_SERVICIO'
)
ORDER BY table_name;


/* ============================================================
   FIN CASO 1
   ============================================================ */
   
   /* ============================================================
   CASO 2: MODIFICACION DEL MODELO
   ============================================================ */


/* ============================================================
   1. ELIMINAR ATRIBUTO DERIVADO COSTO_TOTAL

   El costo total puede calcularse utilizando los costos
   de los servicios, por lo que no debe almacenarse.
   ============================================================ */

ALTER TABLE MANTENCION
    DROP COLUMN costo_total;


/* ============================================================
   2. MODIFICAR CLAVE PRIMARIA DE MANTENCION

   Cada mantencion se identifica por:
   - numero de mantencion
   - sucursal
   ============================================================ */


/* Primero se elimina la FK antigua desde DETALLE_SERVICIO */

ALTER TABLE DETALLE_SERVICIO
    DROP CONSTRAINT DETALLE_SERVICIO_FK_MANT;


/* Se elimina la PK original de MANTENCION */

ALTER TABLE MANTENCION
    DROP CONSTRAINT MANTENCION_PK;


/* Se crea la nueva PK compuesta */

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_PK
    PRIMARY KEY (
        num_mantencion,
        cod_sucursal
    );


/* ============================================================
   3. AJUSTAR DETALLE_SERVICIO

   Ahora DETALLE_SERVICIO debe identificar tambien
   la sucursal de la mantencion.
   ============================================================ */

ALTER TABLE DETALLE_SERVICIO
    ADD cod_sucursal CHAR(3);


/* Se completa la nueva columna como obligatoria.

   Esto puede hacerse porque en este punto aun no hemos
   realizado el poblamiento del Caso 3.
*/

ALTER TABLE DETALLE_SERVICIO
    MODIFY cod_sucursal NOT NULL;


/* Eliminamos la PK original para incorporar la sucursal */

ALTER TABLE DETALLE_SERVICIO
    DROP CONSTRAINT DETALLE_SERVICIO_PK;


/* Nueva PK de DETALLE_SERVICIO */

ALTER TABLE DETALLE_SERVICIO
    ADD CONSTRAINT DETALLE_SERVICIO_PK
    PRIMARY KEY (
        mantencion_num,
        cod_sucursal,
        cod_servicio
    );


/* Nueva FK compuesta hacia MANTENCION */

ALTER TABLE DETALLE_SERVICIO
    ADD CONSTRAINT DETALLE_SERVICIO_FK_MANT
    FOREIGN KEY (
        mantencion_num,
        cod_sucursal
    )
    REFERENCES MANTENCION (
        num_mantencion,
        cod_sucursal
    );


/* ============================================================
   4. EMAIL DE CLIENTE UNICO

   El email es opcional, pero si se registra
   no puede repetirse.
   ============================================================ */

ALTER TABLE CLIENTE
    ADD CONSTRAINT CLIENTE_UN_EMAIL
    UNIQUE (email);


/* ============================================================
   5. VALIDACION DEL DIGITO VERIFICADOR

   Valores permitidos:
   0,1,2,3,4,5,6,7,8,9,K
   ============================================================ */

ALTER TABLE CLIENTE
    ADD CONSTRAINT CLIENTE_CK_DV
    CHECK (
        dv IN (
            '0',
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            'K'
        )
    );


/* ============================================================
   6. SUELDO MINIMO DEL MECANICO

   El sueldo no puede ser inferior a $510.000.
   ============================================================ */

ALTER TABLE MECANICO
    ADD CONSTRAINT MECANICO_CK_SUELDO
    CHECK (
        sueldo >= 510000
    );


/* ============================================================
   7. ESTADOS VALIDOS DE UNA MANTENCION

   Valores permitidos:
   Reserva
   Ingresado
   Entregado
   Anulado
   ============================================================ */

ALTER TABLE MANTENCION
    ADD CONSTRAINT MANTENCION_CK_ESTADO
    CHECK (
        estado IN (
            'Reserva',
            'Ingresado',
            'Entregado',
            'Anulado'
        )
    );


/* ============================================================
   FIN CASO 2
   ============================================================ */

/* ============================================================
   CASO 3: POBLAMIENTO DEL MODELO
   ============================================================ */


/* ============================================================
   1. CREACION DE SECUENCIAS
   ============================================================ */

CREATE SEQUENCE SEQ_CIUDAD
    START WITH 165
    INCREMENT BY 5
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE SEQ_SERVICIO
    START WITH 400
    INCREMENT BY 2
    NOCACHE
    NOCYCLE;


/* ============================================================
   2. POBLAMIENTO DE PAIS
   IDENTITY genera: 9, 12, 15
   ============================================================ */

INSERT INTO PAIS (nom_pais)
VALUES ('Chile');

INSERT INTO PAIS (nom_pais)
VALUES ('Peru');

INSERT INTO PAIS (nom_pais)
VALUES ('Colombia');


/* ============================================================
   3. POBLAMIENTO DE CIUDAD
   SEQ_CIUDAD genera: 165, 170, 175
   ============================================================ */

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Santiago', 9);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Lima', 12);

INSERT INTO CIUDAD (id_ciudad, nom_ciudad, cod_pais)
VALUES (SEQ_CIUDAD.NEXTVAL, 'Bogota', 15);


/* ============================================================
   4. POBLAMIENTO DE SUCURSAL
   ============================================================ */

INSERT INTO SUCURSAL
    (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES
    ('S01', 'Providencia', 'Av. A. Varas', 234, 165);

INSERT INTO SUCURSAL
    (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES
    ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);

INSERT INTO SUCURSAL
    (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES
    ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);


/* ============================================================
   5. POBLAMIENTO DE SERVICIO
   SEQ_SERVICIO genera: 400, 402, 404, 406
   ============================================================ */

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Luces', 45000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Desabolladura', 67000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Revision Frenos', 30000);

INSERT INTO SERVICIO (id_servicio, descripcion, costo)
VALUES (SEQ_SERVICIO.NEXTVAL, 'Cambio Puerta Trasera', 50000);


/* ============================================================
   6. POBLAMIENTO DE MECANICO
   COD_MECANICO es IDENTITY:
   460, 467, 474, 481, 488, 495, 502, 509, 516, 523
   ============================================================ */

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Jorge', 'Pablo', 'Soto', 'Sierra',
     5400000, 2759000, 223580, NULL);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Pedro', 'Jose', 'Manriquez', 'Corral',
     NULL, 759000, 23980, NULL);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Sandra', 'Joseta', 'Letelier', 'S.',
     NULL, 659000, 22358, 460);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Felipe', 'M.', 'Vidal', 'A.',
     NULL, 759000, 23580, 460);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Jose', 'Miguel', 'Troncoso', 'B.',
     NULL, 659000, 44580, 474);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Juan', 'Pablo', 'Sanchez', 'R.',
     NULL, 859000, 23380, 474);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Carlos', 'Felipe', 'Soto', 'J.',
     NULL, 597000, 23580, 474);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Alberto', 'P.', 'Cerda', 'Ramirez',
     NULL, 559000, 22380, 460);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Alejandra', 'Gabriela', 'Infanti', 'R.',
     NULL, 659000, 22380, 460);

INSERT INTO MECANICO
    (pnombre, snombre, apaterno, amaterno,
     bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES
    ('Roberto', 'Patricio', 'Gutierrez', 'Sosa',
     NULL, 859000, 22380, 460);


/* ============================================================
   7. POBLAMIENTO DE MANTENCION
   ============================================================ */

INSERT INTO MANTENCION
    (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida,
     patente_auto, cod_mecanico, estado)
VALUES
    (101, 'S01', TO_DATE('12-04-2023', 'DD-MM-YYYY'),
     NULL, NULL, 481, 'Reserva');

INSERT INTO MANTENCION
    (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida,
     patente_auto, cod_mecanico, estado)
VALUES
    (102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'),
     TO_DATE('21-02-2023', 'DD-MM-YYYY'),
     NULL, 502, 'Entregado');

INSERT INTO MANTENCION
    (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida,
     patente_auto, cod_mecanico, estado)
VALUES
    (103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'),
     NULL, NULL, 502, 'Anulado');

INSERT INTO MANTENCION
    (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida,
     patente_auto, cod_mecanico, estado)
VALUES
    (104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'),
     TO_DATE('18-08-2023', 'DD-MM-YYYY'),
     NULL, 509, 'Entregado');

INSERT INTO MANTENCION
    (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida,
     patente_auto, cod_mecanico, estado)
VALUES
    (105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'),
     NULL, NULL, 509, 'Ingresado');


COMMIT;


/* ============================================================
   VERIFICACION DEL CASO 3
   ============================================================ */

SELECT * FROM PAIS ORDER BY id_pais;
SELECT * FROM CIUDAD ORDER BY id_ciudad;
SELECT * FROM SUCURSAL ORDER BY id_sucursal;
SELECT * FROM SERVICIO ORDER BY id_servicio;
SELECT * FROM MECANICO ORDER BY cod_mecanico;
SELECT * FROM MANTENCION ORDER BY num_mantencion, cod_sucursal;


/* ============================================================
   FIN CASO 3
   ============================================================ */
   
   
   /* ============================================================
   CASO 4: RECUPERACION DE DATOS
   ============================================================ */


/* ============================================================
   INFORME 1:
   SIMULACION DE REBAJA SELECTIVA DE IMPUESTOS
   ============================================================

   Se consideran los mecanicos que:
   - No poseen bono de jefatura.
   - Tienen impuestos inferiores a $40.000.

   El impuesto rebajado corresponde al 80% del
   impuesto actual.
   ============================================================ */

SELECT
    cod_mecanico
        AS "ID MECANICO",

    pnombre || ' ' || apaterno
        AS "NOMBRE MECANICO",

    sueldo
        AS "SALARIO",

    monto_impuestos
        AS "IMPUESTO ACTUAL",

    monto_impuestos * 0.80
        AS "IMPUESTO REBAJADO",

    sueldo - (monto_impuestos * 0.80)
        AS "SUELDO CON REBAJA IMPUESTOS"

FROM MECANICO

WHERE bono_jefatura IS NULL
  AND monto_impuestos < 40000

ORDER BY
    monto_impuestos DESC,
    apaterno ASC;


/* ============================================================
   INFORME 2:
   CALCULO DE REAJUSTE DE SUELDOS
   ============================================================

   Se consideran los mecanicos que:
   - Tienen sueldo entre $600.000 y $900.000
     O
   - No tienen supervisor asignado.

   El ajuste corresponde al 5% del sueldo actual.
   ============================================================ */

SELECT
    cod_mecanico
        AS "IDENTIFICADOR",

    pnombre || ' ' || snombre || ' ' || apaterno
        AS "MECANICO",

    sueldo
        AS "SALARIO ACTUAL",

    sueldo * 0.05
        AS "AJUSTE",

    sueldo + (sueldo * 0.05)
        AS "SUELDO_REAJUSTADO"

FROM MECANICO

WHERE sueldo BETWEEN 600000 AND 900000
   OR cod_supervisor IS NULL

ORDER BY
    sueldo ASC,
    pnombre || ' ' || snombre || ' ' || apaterno DESC;


/* ============================================================
   FIN CASO 4
   ============================================================ */
