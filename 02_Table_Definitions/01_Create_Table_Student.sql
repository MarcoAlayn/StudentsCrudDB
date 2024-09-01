CREATE TABLE student
(
    student_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(45) NOT NULL,
    middle_name NVARCHAR(45) NOT NULL,
    first_name NVARCHAR(45) NOT NULL,
    gender CHAR(1) NOT NULL CHECK( gender IN ('M','F')) ,
    created_on DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_on DATETIME2 NOT NULL,
);

CREATE INDEX student_last_name_idx ON student(last_name)