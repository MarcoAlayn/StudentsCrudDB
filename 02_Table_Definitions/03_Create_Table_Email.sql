CREATE TABLE email
(
    email NVARCHAR(100) NOT NULL PRIMARY KEY,
    student_id INT NOT NULL,
    email_type NVARCHAR(30) NOT NULL CHECK(email_type IN('Personal','Escolar', 'Trabajo')),
    created_on DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_on DATETIME2 NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE INDEX student_email_fk_idx ON email(student_id)