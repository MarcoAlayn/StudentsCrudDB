CREATE TABLE phone
(
    phone_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    phone VARCHAR(30) NOT NULL,
    phone_type VARCHAR(30) NOT NULL CHECK(phone_type IN ('Personal','Trabajo','Casa')),
    country_code NVARCHAR(5) NOT NULL,
    area_code VARCHAR(5) NOT NULL,
    created_on DATETIME2 DEFAULT GETDATE(),
    updated_on DATETIME2,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE INDEX student_phone_idx ON phone(student_id)