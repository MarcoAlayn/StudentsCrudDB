CREATE PROCEDURE sp_student
    @opt INT,

    @student_id INT = NULL,
    @first_name NVARCHAR(45) = NULL,
    @middle_name NVARCHAR(45)= NULL,
    @last_name NVARCHAR(45)= NULL,
    @gender CHAR(1)= NULL,

    @address_line NVARCHAR(100)=NULL,
    @city NVARCHAR(45)=NULL,
    @zip_postcode NVARCHAR(45)=NULL,
    @state NVARCHAR(45)=NULL,

    @email NVARCHAR(100)=NULL,
    @email_type NVARCHAR(30)=NULL,

    @phone VARCHAR(30) = NULL,
    @phone_type VARCHAR(30) = NULL,
    @country_code VARCHAR(5)=NULL,
    @area_code VARCHAR(5)=NULL

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        --get all students
        -- Get all students
IF @opt = 1
BEGIN
        SELECT
            s.student_id AS StudentId,
            s.first_name AS FirstName,
            s.middle_name AS MiddleName,
            s.last_name AS LastName,
            s.gender AS Gender,
            s.created_on AS StudentCreatedOn,
            s.updated_on AS StudentUpdatedOn,

            a.student_id AS AddressStudentId,
            a.address_line AS AddressLine,
            a.city AS City,
            a.zip_postcode AS ZipPostcode,
            a.state AS State,

            e.student_id AS EmailStudentId,
            e.email AS Email,
            e.email_type AS EmailType,
            e.created_on AS EmailCreatedOn,
            e.updated_on AS EmailUpdatedOn,

            p.student_id AS PhoneStudentId,
            p.phone AS Phone,
            p.phone_type AS PhoneType,
            p.country_code AS CountryCode,
            p.area_code AS AreaCode,
            p.created_on AS PhoneCreatedOn,
            p.updated_on AS PhoneUpdatedOn

        FROM student s
            LEFT JOIN address a ON s.student_id = a.student_id
            LEFT JOIN email e ON s.student_id = e.student_id
            LEFT JOIN phone p ON s.student_id = p.student_id
    END


        --get student by id

        --validations
        IF @opt = 2
        BEGIN

        IF @student_id IS NULL
            BEGIN
            RAISERROR('El ID del estudiante es necesario para esta operación.',16,1)
            RETURN
        END

        IF NOT EXISTS (SELECT 1
        FROM student
        WHERE student_id = @student_id)
        BEGIN
            RAISERROR('El estudiante no existe',16,1)
            RETURN
        END

        --retreive information
        SELECT
            s.student_id AS StudentId,
            s.first_name AS FirstName,
            s.middle_name AS MiddleName,
            s.last_name LastName,
            s.gender AS Gender,
            s.created_on AS StudentCreatedOn,
            s.updated_on AS StudentUpdatedOn,

            a.student_id AS AddressStudentId,
            a.address_line AS AddressLine,
            a.city AS City,
            a.zip_postcode AS ZipPostcode,
            a.state AS State,

            e.student_id AS EmailStudentId,
            e.email AS Email,
            e.email_type AS EmailType,
            e.created_on AS EmailCreatedOn,
            e.updated_on AS EmailUpdatedOn,

            p.student_id AS  PhoneStudentId,
            p.phone AS Phone,
            p.phone_type AS PhoneType,
            p.country_code AS CountryCode,
            p.area_code AS AreaCode,
            p.created_on AS PhoneCreatedOn,
            p.updated_on AS PhoneUpdatedOn

        FROM student s
            LEFT JOIN address a ON s.student_id = a.student_id
            LEFT JOIN email e ON s.student_id = e.student_id
            LEFT JOIN phone p ON s.student_id = p.student_id
        WHERE s.student_id = @student_id

    END
        --create student
        IF @opt = 3
        BEGIN

        --validations
        IF @first_name IS NULL OR @middle_name IS NULL OR @last_name IS NULL OR @gender IS NULL OR
            @address_line IS NULL OR @city IS NULL OR @zip_postcode IS NULL OR @state IS NULL OR
            @email IS NULL OR @email_type IS NULL OR
            @phone IS NULL OR @phone_type IS NULL OR @country_code IS NULL OR @area_code IS NULL
            BEGIN
            RAISERROR('Todos los campos son obligatorios',16,1)
            RETURN
        END

        IF EXISTS (SELECT 1
        FROM student
        WHERE first_name = @first_name AND middle_name = @middle_name AND last_name = @last_name)
        BEGIN
            RAISERROR('Ya existe un estudiante con ese nombre', 16, 1)
            RETURN
        END

        IF EXISTS (SELECT 1
        FROM email
        WHERE email = @email)
        BEGIN
            RAISERROR('El correo electrónico ya existe para otro estudiante',16,1)
            RETURN
        END

        IF EXISTS (SELECT 1
        FROM phone
        WHERE phone = @phone)
        BEGIN
            RAISERROR('El número teléfonico ya existe para otro estudiante',16,1)
            RETURN
        END

        IF @email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('El formato de email no es valido',16,1)
            RETURN
        END

        IF @gender NOT IN ('M','F')
        BEGIN
            RAISERROR('El valor de genero solo puede ser "M" o "F"',16,1)
            RETURN
        END

        IF @email_type NOT IN ('Personal','Escolar', 'Trabajo')
        BEGIN
            RAISERROR('El valor de tipo de email debe ser "Personal","Escolar" o "Trabajo".',16,1)
            RETURN
        END

        IF @phone_type NOT IN ('Personal','Trabajo','Casa')
        BEGIN
            RAISERROR('El valor de tipo de numero debe ser "Personal","Trabajo" o "Casa".',16,1)
            RETURN
        END

        --insert student
        INSERT INTO student
            (first_name, middle_name, last_name, gender)
        VALUES
            (@first_name, @middle_name, @last_name, @gender)

        --get the ID of the last inserted student 
        SET @student_id = SCOPE_IDENTITY()

        --insert direction
        INSERT INTO address
            (student_id, address_line,city,zip_postcode,state)
        VALUES
            (@student_id, @address_line, @city, @zip_postcode, @state)

        --insert email
        INSERT INTO email
            (student_id,email,email_type)
        VALUES
            (@student_id, @email, @email_type)

        --insert phone
        INSERT INTO phone
            (student_id, phone,phone_type,country_code,area_code)
        VALUES
            (@student_id, @phone, @phone_type, @country_code, @area_code)

    END
        --update student
        IF @opt = 4
        BEGIN

        --validations
        IF @student_id IS NULL
            BEGIN
            RAISERROR('El ID del estudiante es necesario para esta operación.',16,1)
            RETURN
        END

        IF NOT EXISTS (SELECT 1
        FROM student
        WHERE student_id = @student_id)
        BEGIN
            RAISERROR('El estudiante no existe',16,1)
            RETURN
        END

        IF EXISTS (SELECT 1
            FROM student
            WHERE first_name = @first_name AND middle_name = @middle_name AND last_name = @last_name
            AND student_id <> @student_id)
        BEGIN
            RAISERROR('Ya existe un estudiante con ese nombre', 16, 1)
            RETURN
        END

        IF EXISTS (SELECT 1
            FROM email
            WHERE email = @email
            AND student_id <> @student_id)
        BEGIN
            RAISERROR('El correo electrónico ya existe para otro estudiante',16,1)
            RETURN
        END

        IF EXISTS (SELECT 1
            FROM phone
            WHERE phone = @phone AND student_id <> @student_id)
        BEGIN
            RAISERROR('El número teléfonico ya existe para otro estudiante',16,1)
            RETURN
        END

        IF @email NOT LIKE '%_@_%._%'
        BEGIN
            RAISERROR('El formato de email no es valido',16,1)
            RETURN
        END

        IF @gender NOT IN ('M','F')
        BEGIN
            RAISERROR('El valor de genero solo puede ser "M" o "F"',16,1)
            RETURN
        END

        IF @email_type NOT IN ('Personal','Escolar', 'Trabajo')
        BEGIN
            RAISERROR('El valor de tipo de email debe ser "Personal","Escolar" o "Trabajo".',16,1)
            RETURN
        END

        IF @phone_type NOT IN ('Personal','Trabajo','Casa')
        BEGIN
            RAISERROR('El valor de tipo de numero debe ser "Personal","Trabajo" o "Casa".',16,1)
            RETURN
        END

        --update student table
        UPDATE student
            SET first_name = ISNULL(@first_name,first_name),
            middle_name = ISNULL(@middle_name, middle_name),
            last_name = ISNULL(@last_name,last_name),
            gender = ISNULL(@gender,gender),
            updated_on = GETDATE()
            WHERE student_id = @student_id

        --update address table
        IF @address_line IS NOT NULL OR @city IS NOT NULL OR @zip_postcode IS NOT NULL OR @state IS NOT NULL
            BEGIN
            UPDATE address
            SET address_line = ISNULL(@address_line,address_line),
            city = ISNULL(@city,city),
            zip_postcode = ISNULL(@zip_postcode,zip_postcode),
            state = ISNULL(@state,state)
            WHERE student_id = @student_id
        END

        --update email table
        IF @email IS NOT NULL OR @email_type IS NOT NULL
        BEGIN
            UPDATE email
            SET email = ISNULL(@email,email),
                email_type = ISNULL(@email_type,email_type),
                updated_on = GETDATE()
                        WHERE student_id = @student_id
        END

        --update phone table
        IF @phone IS NOT NULL OR @phone_type IS NOT NULL OR @country_code IS NOT NULL OR @area_code IS NOT NULL
            BEGIN
            UPDATE phone
                SET phone = ISNULL(@phone,phone),
                phone_type =ISNULL(@phone_type,phone_type),
                country_code = ISNULL(@country_code,country_code),
                area_code = ISNULL(@area_code,area_code),
                updated_on = GETDATE()
                WHERE student_id = @student_id

        END
    END
        --delete student

        IF @opt = 5
        BEGIN

        --validations
        IF @student_id IS NULL
            BEGIN
            RAISERROR('El ID del estudiante es necesario para esta operación.',16,1)
            RETURN
        END

        IF NOT EXISTS (SELECT 1
        FROM student
        WHERE student_id = @student_id)
        BEGIN
            RAISERROR('El estudiante no existe',16,1)
            RETURN
        END

        --remove dependencies before main record
        DELETE FROM address WHERE student_id = @student_id
        DELETE FROM email WHERE student_id = @student_id
        DELETE FROM phone WHERE student_id = @student_id
        DELETE FROM student WHERE student_id = @student_id
    END

        --make permanent changes
        COMMIT TRANSACTION;
        END TRY

        --error handler
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage VARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage,16,1)
        END CATCH

END