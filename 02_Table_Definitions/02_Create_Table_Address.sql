CREATE TABLE address
(
    address_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    Address_line NVARCHAR(100) NOT NULL,
    city NVARCHAR(45) NOT NULL,
    zip_postcode NVARCHAR(45) NOT NULL,
    state NVARCHAR(45) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

CREATE INDEX address_student_FK_idx ON address(student_id)