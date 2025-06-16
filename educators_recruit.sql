DROP TABLE IF EXISTS Educator;
GO

-- Educators Recruit T-SQL implementation
-- Create table
CREATE TABLE Educator (
    EducatorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    CollegeAttended VARCHAR(100) NOT NULL,
    DegreeTitle VARCHAR(100) NOT NULL,
    Media VARCHAR(50) NOT NULL,
    DateContacted DATE NOT NULL,
    SchoolPlaced VARCHAR(100) NULL,
    DateFoundJob DATE NULL,
    CONSTRAINT CHK_Gender CHECK (Gender IN ('male','female')),
    CONSTRAINT CHK_DateOrder CHECK (DateFoundJob IS NULL OR DateFoundJob >= DateContacted),
    CONSTRAINT CHK_PlacementFields CHECK (
        (DateFoundJob IS NOT NULL AND SchoolPlaced IS NOT NULL) OR
        (DateFoundJob IS NULL AND SchoolPlaced IS NULL)
    ),
    CONSTRAINT CHK_ContactDOB CHECK (DateContacted >= DOB)
);

-- Insert sample data
INSERT INTO Educator (FirstName, LastName, DOB, Gender, CollegeAttended, DegreeTitle, Media, DateContacted, SchoolPlaced, DateFoundJob) VALUES
('Mary', 'Lynn', '2000-09-13', 'female', 'Excelsior College', 'BA in Mathematics Education', 'magazine', '2022-05-02', 'Brooklyn High School', '2022-05-09'),
('Josh', 'Frank', '1998-04-23', 'male', 'Georgia State University', 'MA in Social Studies Education', 'social media site', '2022-02-12', 'Manhattan Elementary School', '2022-05-09'),
('Charles', 'Smith', '1994-07-09', 'male', 'Excelsior College', 'PhD in Education', 'social media site', '2021-08-07', 'New York City Day School', '2021-08-12'),
('Samantha', 'Brown', '1999-09-24', 'female', 'Columbia University', 'BA in English Education', 'newspaper', '2021-05-23', 'Brooklyn High School', '2021-07-30'),
('Howard', 'Lang', '1998-08-04', 'male', 'Georgia State University', 'MA in History Education', 'word of mouth', '2022-01-31', NULL, NULL),
('Sarah', 'Blanks', '1995-10-20', 'female', 'Columbia University', 'MA in Science Education', 'social media', '2020-05-23', 'New York City Day School', '2020-08-17'),
('Ella', 'Lewis', '2000-08-22', 'female', 'Excelsior College', 'BA in English Education', 'word of mouth', '2022-04-01', NULL, NULL),
('Julie', 'Goldman', '1997-03-30', 'female', 'University of Denver', 'MA in Social Studies Education', 'social media', '2020-07-14', 'Manhattan Elementary School', '2020-08-17');

-- Report 1: number of students placed within two weeks grouped by college
SELECT CollegeAttended, COUNT(*) AS PlacedWithinTwoWeeks
FROM Educator
WHERE DateFoundJob IS NOT NULL
  AND DATEDIFF(day, DateContacted, DateFoundJob) < 14
GROUP BY CollegeAttended;

-- Report 2: placements by gender
SELECT Gender, COUNT(*) AS NumberPlaced
FROM Educator
WHERE DateFoundJob IS NOT NULL
GROUP BY Gender;

-- Report 3: average contacts per day and counts per media
SELECT AVG(ContactsPerDay) AS AverageContactsPerDay
FROM (
    SELECT DateContacted, COUNT(*) AS ContactsPerDay
    FROM Educator
    GROUP BY DateContacted
) AS DailyContacts;

SELECT Media, COUNT(*) AS NumberFoundUs
FROM Educator
GROUP BY Media;

-- Report 4: average placements per day
SELECT AVG(PlacedPerDay) AS AveragePlacedPerDay
FROM (
    SELECT DateFoundJob, COUNT(*) AS PlacedPerDay
    FROM Educator
    WHERE DateFoundJob IS NOT NULL
    GROUP BY DateFoundJob
) AS DailyPlacement;

-- Report 5: placements per day per degree
SELECT DateFoundJob, DegreeTitle, COUNT(*) AS NumberPlaced
FROM Educator
WHERE DateFoundJob IS NOT NULL
GROUP BY DateFoundJob, DegreeTitle
ORDER BY DateFoundJob, DegreeTitle;

-- Report 6: list of educators with age at contact
SELECT FirstName, LastName,
       DATEDIFF(year, DOB, DateContacted) -
       CASE WHEN DATEADD(year, DATEDIFF(year, DOB, DateContacted), DOB) > DateContacted THEN 1 ELSE 0 END AS AgeAtContact,
       DegreeTitle
FROM Educator
ORDER BY LastName, FirstName;

