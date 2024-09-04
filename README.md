# **Documentación del CRUD de Estudiantes para StudentsCrudDB**

## **Introducción**

Esta documentación describe el sistema CRUD (Crear, Leer, Actualizar, Eliminar) para gestionar estudiantes en una base de datos SQL Server denominada `StudentsCrudDB`. El sistema está diseñado para almacenar y manejar información sobre estudiantes, incluyendo datos personales, direcciones, correos electrónicos y números telefónicos.

## **Estructura de la Base de Datos**

### **Tablas**

1. **student**

   - **Descripción**: Almacena información básica del estudiante.
   - **Campos**:
     - `student_id` (INT, PK, IDENTITY): Identificador único del estudiante.
     - `last_name` (NVARCHAR(45)): Apellido del estudiante.
     - `middle_name` (NVARCHAR(45)): Segundo nombre del estudiante.
     - `first_name` (NVARCHAR(45)): Primer nombre del estudiante.
     - `gender` (CHAR(1)): Género del estudiante ('M' para masculino, 'F' para femenino).
     - `created_on` (DATETIME2): Fecha y hora de creación del registro.
     - `updated_on` (DATETIME2): Fecha y hora de la última actualización del registro.

2. **address**

   - **Descripción**: Almacena la dirección del estudiante.
   - **Campos**:
     - `address_id` (INT, PK, IDENTITY): Identificador único de la dirección.
     - `student_id` (INT, FK): Identificador del estudiante.
     - `address_line` (NVARCHAR(100)): Línea de la dirección.
     - `city` (NVARCHAR(45)): Ciudad.
     - `zip_postcode` (NVARCHAR(45)): Código postal.
     - `state` (NVARCHAR(45)): Estado.

3. **email**

   - **Descripción**: Almacena los correos electrónicos del estudiante.
   - **Campos**:
     - `email` (NVARCHAR(100), PK): Correo electrónico del estudiante.
     - `student_id` (INT, FK): Identificador del estudiante.
     - `email_type` (NVARCHAR(30)): Tipo de correo electrónico ('Personal', 'Escolar', 'Trabajo').
     - `created_on` (DATETIME2): Fecha y hora de creación del registro.
     - `updated_on` (DATETIME2): Fecha y hora de la última actualización del registro.

4. **phone**
   - **Descripción**: Almacena los números telefónicos del estudiante.
   - **Campos**:
     - `phone_id` (INT, PK, IDENTITY): Identificador único del teléfono.
     - `student_id` (INT, FK): Identificador del estudiante.
     - `phone` (VARCHAR(30)): Número telefónico.
     - `phone_type` (VARCHAR(30)): Tipo de teléfono ('Personal', 'Trabajo', 'Casa').
     - `country_code` (NVARCHAR(5)): Código del país.
     - `area_code` (VARCHAR(5)): Código de área.
     - `created_on` (DATETIME2): Fecha y hora de creación del registro.
     - `updated_on` (DATETIME2): Fecha y hora de la última actualización del registro.

## **Procedimientos Almacenados**

### **1. Crear Estudiante**

**Descripción**: Inserta un nuevo estudiante junto con su dirección, correo electrónico y teléfono.

**Procedimiento**:

```sql
CREATE PROCEDURE CreateStudent
    @first_name NVARCHAR(45),
    @middle_name NVARCHAR(45),
    @last_name NVARCHAR(45),
    @gender CHAR(1),
    @address_line NVARCHAR(100),
    @city NVARCHAR(45),
    @zip_postcode NVARCHAR(45),
    @state NVARCHAR(45),
    @email NVARCHAR(100),
    @email_type NVARCHAR(30),
    @phone VARCHAR(30),
    @phone_type VARCHAR(30),
    @country_code NVARCHAR(5),
    @area_code VARCHAR(5)
AS
BEGIN
	--Validaciones
	...

    -- Insertar en la tabla student
    INSERT INTO student (first_name, middle_name, last_name, gender)
    VALUES (@first_name, @middle_name, @last_name, @gender);

    -- Obtener el ID del estudiante recién creado
    DECLARE @student_id INT = SCOPE_IDENTITY();

    -- Insertar en la tabla address
    INSERT INTO address (student_id, address_line, city, zip_postcode, state)
    VALUES (@student_id, @address_line, @city, @zip_postcode, @state);

    -- Insertar en la tabla email
    INSERT INTO email (student_id, email, email_type)
    VALUES (@student_id, @email, @email_type);

    -- Insertar en la tabla phone
    INSERT INTO phone (student_id, phone, phone_type, country_code, area_code)
    VALUES (@student_id, @phone, @phone_type, @country_code, @area_code);
END;
```

**Explicación**:

- **INSERT INTO student**: Crea un nuevo registro en la tabla `student`.
- **SCOPE_IDENTITY()**: Obtiene el ID del estudiante recién creado para usarlo en las tablas relacionadas.
- **INSERT INTO address, email, phone**: Inserta los datos correspondientes en las tablas `address`, `email` y `phone`.

**Ejemplo de Ejecución**:

```sql
EXEC sp_student
    @opt = 3,
    @first_name = 'Ana',
    @middle_name = 'Isabel',
    @last_name = 'Gómez',
    @gender = 'F',
    @address_line = 'Calle de la Paz 123',
    @city = 'Madrid',
    @zip_postcode = '28001',
    @state = 'Madrid',
    @email = 'ana.gomez@example.com',
    @email_type = 'Personal',
    @phone = '612345678',
    @phone_type = 'Personal',
    @country_code = '34',
    @area_code = '91';
```

### **2. Leer Estudiantes**

**Descripción**: Obtiene la lista de todos los estudiantes con sus detalles completos.

**Procedimiento**:

```sql
CREATE PROCEDURE GetAllStudents
AS
BEGIN
    SELECT s.student_id AS StudentId, s.first_name AS FirstName, s.middle_name AS MiddleName, s.last_name AS LastName, s.gender AS Gender, s.created_on AS StudentCreatedOn, s.updated_on AS StudentUpdatedOn,
           a.address_line AS AddressLine, a.city AS City, a.zip_postcode AS ZipPostcode, a.state AS State,
           e.email AS Email, e.email_type AS EmailType, e.created_on AS EmailCreatedOn, e.updated_on AS EmailUpdatedOn,
           p.phone AS Phone, p.phone_type AS PhoneType, p.country_code AS CountryCode, p.area_code AS AreaCode, p.created_on AS PhoneCreatedOn, p.updated_on AS PhoneUpdatedOn
    FROM student s
    LEFT JOIN address a ON s.student_id = a.student_id
    LEFT JOIN email e ON s.student_id = e.student_id
    LEFT JOIN phone p ON s.student_id = p.student_id;
END;
```

**Explicación**:

- **LEFT JOIN**: Une las tablas `student`, `address`, `email` y `phone` para proporcionar una vista completa del estudiante con todos los datos asociados.

**Ejemplo de Ejecución**:

```sql
EXEC sp_student @opt=1
```

### **3. Leer Estudiante por ID**

**Descripción**: Obtiene la información de un estudiante específico basado en su ID.

**Procedimiento**:

```sql
CREATE PROCEDURE GetStudentById
    @student_id INT
AS
BEGIN
	--Validaciones
	...

    SELECT s.student_id AS StudentId, s.first_name AS FirstName, s.middle_name AS MiddleName, s.last_name AS LastName, s.gender AS Gender, s.created_on AS StudentCreatedOn, s.updated_on AS StudentUpdatedOn,
           a.address_line AS AddressLine, a.city AS City, a.zip_postcode AS ZipPostcode, a.state AS State,
           e.email AS Email, e.email_type AS EmailType, e.created_on AS EmailCreatedOn, e.updated_on AS EmailUpdatedOn,
           p.phone AS Phone, p.phone_type AS PhoneType, p.country_code AS CountryCode, p.area_code AS AreaCode, p.created_on AS PhoneCreatedOn, p.updated_on AS PhoneUpdatedOn
    FROM student s
    LEFT JOIN address a ON s.student_id = a.student_id
    LEFT JOIN email e ON s.student_id = e.student_id
    LEFT JOIN phone p ON s.student_id = p.student_id
    WHERE s.student_id = @student_id;
END;
```

**Explicación**:

- **WHERE s.student_id = @student_id**: Filtra los resultados para mostrar solo el estudiante con el ID especificado.

**Ejemplo de Ejecución**:

```sql
EXEC sp_student @opt=2, @student_id=32
```

### **4. Actualizar Estudiante**

**Descripción**: Actualiza la información de un estudiante existente.

**Procedimiento**:

```sql
CREATE PROCEDURE UpdateStudent
    @student_id INT,
    @first_name NVARCHAR(45),
    @middle_name NVARCHAR(45),
    @last_name NVARCHAR(45),
    @gender CHAR(1),
    @address_line NVARCHAR(100),
    @city NVARCHAR(45),
    @zip_postcode NVARCHAR(45),
    @state NVARCHAR(45),
    @email NVARCHAR(100),
    @email_type NVARCHAR(30),
    @phone VARCHAR(30),
    @phone_type VARCHAR(30),
    @country_code NVARCHAR(5),
    @area_code VARCHAR(5)
AS
BEGIN
	--Validaciones
	...

    -- Actualizar en la tabla student
    UPDATE student
    SET first_name = @first_name, middle_name = @middle_name, last_name = @last_name, gender = @gender, updated_on = GETDATE()
    WHERE student_id = @student_id;

    -- Actualizar en la tabla address
    UPDATE address
    SET address_line = @address_line, city = @city, zip_postcode = @zip_postcode, state = @state
    WHERE student_id = @student_id;

    -- Actualizar en la tabla email
    UPDATE email
    SET email

 = @email, email_type = @email_type, updated_on = GETDATE()
    WHERE student_id = @student_id;

    -- Actualizar en la tabla phone
    UPDATE phone
    SET phone = @phone, phone_type = @phone_type, country_code = @country_code, area_code = @area_code, updated_on = GETDATE()
    WHERE student_id = @student_id;
END;
```

**Explicación**:

- **UPDATE**: Actualiza los registros existentes en las tablas `student`, `address`, `email` y `phone`.

**Ejemplo de Ejecución**:

```sql
EXEC sp_student @opt=4, @student_id=32, @first_name='José'
```

### **5. Eliminar Estudiante**

**Descripción**: Elimina un estudiante y todos los datos relacionados.

**Procedimiento**:

```sql
CREATE PROCEDURE DeleteStudent
    @student_id INT
AS
BEGIN
	--Validaciones
	...

    -- Eliminar registros relacionados en phone, email y address
    DELETE FROM phone WHERE student_id = @student_id;
    DELETE FROM email WHERE student_id = @student_id;
    DELETE FROM address WHERE student_id = @student_id;

    -- Eliminar el registro del estudiante
    DELETE FROM student WHERE student_id = @student_id;
END;
```

**Explicación**:

- **DELETE FROM phone, email, address**: Elimina todos los datos relacionados con el estudiante en las tablas `phone`, `email` y `address`.
- **DELETE FROM student**: Finalmente, elimina el registro del estudiante de la tabla `student`.

**Ejemplo de Ejecución**:

```sql
EXEC sp_student @opt=5, @student_id=32
```

## **Conclusión**

Este sistema CRUD permite gestionar completamente la información de los estudiantes mediante procedimientos almacenados en SQL Server. Cada procedimiento está diseñado para manejar un aspecto específico del CRUD y garantizar la integridad de los datos mediante la eliminación en cascada y actualizaciones en múltiples tablas.
