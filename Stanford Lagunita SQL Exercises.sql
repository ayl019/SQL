--Basic SELECT statement
--Student names and majors for which they've applied
SELECT DISTINCT sName, major FROM Student, Apply WHERE Student.sID = Apply.sID;

--Names and GPAs of students with sizeHS < 1000 applying to CS at Stanford
SELECT sName, GPA 
FROM Student, Apply 
WHERE Student.sID = Apply.sID AND sizeHS < 1000 AND major = 'CS' AND cname = 'Stanford';

--All large campuses with CS applicants
SELECT DISTINCT College.cName 
FROM College, Apply 
WHERE College.cName = Apply.cName AND major = 'CS' AND enrollment > 20000;

--Application information
SELECT Student.sID, sName, GPA, Apply.cName, enrollment 
FROM Student, Apply, College 
WHERE Student.sID = Apply.sID AND Apply.cName = College.cName ORDER BY GPA DESC, enrollment;

--Applicants to bio majors
SELECT sid, major 
FROM Apply 
WHERE major LIKE '%bio%';

--Add scaled GPA based on sizeHS
SELECT sid, sName, GPA, sizeHS, GPA*(sizeHS/1000.0) as scaledGPA 
FROM Student;

--Table variables and set operators
--Same previous application information but with table variables instead
SELECT S.sID, sName, GPA, A.cName, enrollment 
FROM Student S, Apply A, College C 
WHERE S.sID = A.sID AND A.cName = C.cName ORDER BY GPA DESC, enrollment;

--Find students with same GPA
SELECT S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA 
FROM Student S1, Student S2 
WHERE S1.GPA = S2.GPA AND S1.sID < S2.sID;

--Union operator
--Eliminates duplicates by default
SELECT cName FROM College 
UNION 
SELECT sName FROM Student ORDER BY cName;
--Retain duplicates
SELECT cName FROM College 
UNION ALL 
SELECT sName FROM Student ORDER BY cName;

--ID for students who applied to both CS and EE
SELECT sID FROM Apply WHERE major = 'CS' 
INTERSECT 
SELECT sID FROM Apply WHERE major = 'EE';
--Same result but without intersect operator
SELECT DISTINCT A1.sID 
FROM Apply A1, Apply A2 
WHERE A1.sID = A2.sID AND A1.major = 'CS' AND A2.major = 'EE';

--ID for student who applied to CS but not EE
SELECT sID FROM Apply WHERE major = 'CS' 
EXCEPT 
SELECT sID FROM Apply where major = 'EE';

--Subqueries in WHERE clause
--IDs and names of students who applied as CS at some school
SELECT sName, sID
FROM Student
WHERE sID in (SELECT sID FROM Apply WHERE major = 'CS');
--Without subquery
SELECT DISTINCT sName, Student.sID
FROM Student, Apply
WHERE Student.sID = Apply.sID AND major = 'CS'
ORDER BY Student.sID;

--Calcuate average GPA of students applied as CS
SELECT GPA
FROM Student
WHERE sid IN (SELECT sid from Apply where major = 'CS');

----IDs and names for student who applied to CS but not EE
SELECT sID, sName
FROM Student
WHERE sID IN (SELECT sID from Apply where major = 'CS')
AND sID NOT IN (SELECT sID from Apply where major = 'EE');

--All colleges such that some other college is in the same state
--EXISTS returns true if subquery contains any row
SELECT cName, state
FROM College C1
WHERE EXISTS (SELECT * from College C2 WHERE C2.state = C1.state
AND C1.cName <> C2.cName);

--College with largest enrollment without using max()
SELECT cName
FROM College C1
WHERE NOT EXISTS (SELECT * FROM College C2 WHERE C2.enrollment > C1.enrollment);

--Student with highest GPA
SELECT sName, GPA
FROM Student S1
WHERE NOT EXISTS (SELECT * FROM Student S2 WHERE S2.GPA > S1.GPA);
--Using ALL
SELECT sName, GPA
FROM Student
WHERE GPA >= ALL(SELECT GPA from Student);

--All students not from smallest HS
SELECT sID, sName, sizeHS
FROM Student
WHERE sizeHS > any (SELECT sizeHS from Student)
ORDER BY sID;
--Without using any
SELECT DISTINCT S1.sID, S1.sName, S1.sizeHS
FROM Student S1, Student S2
WHERE S1.sID <> S2.sID AND S1.sizeHS > S2.sizeHS ORDER BY sID;

SELECT sID, sName, sizeHS
FROM Student S1
WHERE exists (SELECT * from Student S2 WHERE S2.sizeHS < S1.sizeHS);

--Find students applied to CS but not EE
SELECT sID, sName
FROM Student
WHERE sID = any (SELECT sID from Apply where major = 'CS')
AND  sID <> all (SELECT sID from Apply where major = 'EE');

--Subqueries in SELECT and FROM
SELECT *
FROM (SELECT sID, sName, GPA, GPA*(sizeHS/1000) as scaledGPA FROM Student) G
WHERE abs(G.scaledGPA - GPA) > 1.0;

--Colleges paired with the highest GPA of their applicants
SELECT DISTINCT College.cName, state, GPA
FROM College, Student, Apply
WHERE College.cName = Apply.cName 
AND Student.sid = Apply.sid
AND GPA >= all(SELECT GPA FROM Student, Apply WHERE Student.sid = Apply.sid AND Apply.cName = College.cName);
--Using subqueries in SELECT
SELECT cName, state, 
(SELECT DISTINCT GPA FROM Apply, Student WHERE College.cName = Apply.cName
AND Apply.sID = Student.sID
AND GPA >= ALL(SELECT GPA FROM Student, Apply WHERE Student.sID = Apply.sID and Apply.cName = College.cName)) as GPA
FROM College;

--The JOIN Family of Operators
--SQL defaults inner join
--Rewrite previous queries using join operator
SELECT sName, major
FROM Student inner join Apply
on Student.sID = Apply.sID;

SELECT sName, GPA
FROM Student join Apply
on Student.sID = Apply.sID WHERE sizeHS < 1000 AND major = 'CS' AND cName = 'Stanford';

SELECT Student.sID, sName, GPA, Apply.cName, enrollment 
FROM (Student join Apply on Student.sID = Apply.sID) join College 
ON Apply.cName = College.cName ORDER BY GPA DESC, enrollment;

SELECT sName, major
FROM Student natural join Apply;

SELECT sName, GPA
FROM Student NATURAL join Apply
WHERE sizeHS < 1000 AND major = 'CS' AND cName = 'Stanford';

--USING cannot be used with ON
SELECT sName, GPA
FROM Student join Apply USING(sID)
WHERE sizeHS < 1000 AND major = 'CS' AND cName = 'Stanford';

SELECT S1.sID, S1.sName, S1.GPA, S2.sID, S2.sName, S2.GPA 
FROM Student S1 JOIN Student S2 USING(GPA)
WHERE S1.sID < S2.sID;

--Left outer join 
--Retains tuples from the left relation even there is no matching tuple on the right relation and padded with NULL values
SELECT sName, sID, cName, major
FROM Student LEFT JOIN Apply USING(sID);
--Without using outer join operator
SELECT sName, Student.sID, cName, major
FROM Student, Apply
WHERE Student.sID = Apply.sID
UNION
SELECT sName, sID, NULL, NULL
from Student
WHERE sID not in (SELECT sID FROM Apply);

--Right outer join
--Retains tuples from the right relation even there is no matching tuple on the left relation and padded with NULL values
INSERT INTO Apply values(321, 'MIT', 'history', 'N');
INSERT INTO Apply values(321, 'MIT', 'psychology', 'Y');
SELECT sName, sID, cName, major
FROM Student RIGHT JOIN Apply USING(sID);

--Full outer join
--Unmatched tuples from both left and right in the result
SELECT sName, sID, cName, major
FROM Student FULL OUTER JOIN Apply USING(sID);
--Without using the full outer join operator
SELECT sName, sID, cName, major
FROM Student LEFT OUTER JOIN Apply USING(sID)
union
SELECT sName, sID, cName, major
FROM Student RIGHT OUTER JOIN Apply USING(sID);
--Without using any join operator
SELECT sName, Student.sID, cName, major
FROM Student, Apply
WHERE Student.sID = Apply.sID
UNION
SELECT sName, sID, NULL, NULL
FROM Student
WHERE sID not in (SELECT sID FROM Apply)
UNION
SELECT NULL, sID, cName, major
FROM Apply
WHERE sID not in (SELECT sID FROM Student);

--Aggregate Functions
--Minimum and average GPA who applied to CS major
SELECT min(GPA), avg(GPA)
FROM Student
WHERE sID in (SELECT sID FROM Apply WHERE major = 'CS');

SELECT Count(*)
FROM College
WHERE enrollment > 15000;

SELECT count(DISTINCT sID)
FROM Apply
WHERE cName = 'Cornell';

--GPA difference of CS and non-CS students
SELECT CS.avgGPA - nonCS.avgGPA
FROM (SELECT avg(GPA) as avgGPA FROM Student WHERE sID in (SELECT sID FROM Apply WHERE major = 'CS')) as CS,
(SELECT avg(GPA) as avgGPA FROM Student WHERE sID NOT IN (SELECT sID FROM Apply WHERE major <> 'CS')) as nonCS;

--Number of applicants to each college
SELECT cName, count(*) FROM Apply GROUP BY cName;

--Total enrollment by state
SELECT state, sum(enrollment) FROM College GROUP BY state;

--Max and min GPA of applicants to each college and major
SELECT cName, major, min(GPA), max(GPA)
FROM Student, Apply
WHERE Student.sID = Apply.sID
GROUP BY cName, major;

--Number of colleges applied by each student
SELECT Student.sID, count(distinct cName)
FROM Student, Apply
WHERE Student.sID = Apply.sID
GROUP BY Student.sID;

--Include students who have not applied to any college
SELECT Student.sID, count(distinct cName)
FROM Student, Apply
WHERE Student.sID = Apply.sID
GROUP BY Student.sID
UNION
SELECT sID, 0
FROM Student
WHERE sID not in (SELECT sID FROM Apply);

--Having clause
SELECT cName
FROM Apply
GROUP BY cName
HAVING count(*) < 5;
--Without using having clause
SELECT DISTINCT cName
FROM Apply A1
WHERE 5 > (SELECT count(*) from Apply A2 WHERE A2.cName = A1.cName);

--Number of colleges having fewer than 5 distinct people applied
SELECT cName
FROM Apply
GROUP BY cName
HAVING count(DISTINCT sID) < 5;

--Majors whose max GPA among applicants is below average
SELECT major
FROM Student, Apply
WHERE Student.sID = Apply.sID
GROUP BY major
HAVING max(GPA) < (SELECT avg(GPA) from Student);

SELECT count(DISTINCT GPA)
FROM Student
WHERE GPA is not null;

--Data modification statement
INSERT INTO College VALUES('Carnegie Mellon', 'PA', 11500);

--Make students who have not applied anywhere applying to Carnegie Mellon
INSERT INTO Apply
SELECT sID, 'Carnegie Mellon', 'CS', NULL
FROM Student
WHERE sID not in (SELECT sID FROM Apply);

--Admit students to Carnegie Mellon for EE for those who are rejected everywhere else
INSERT INTO Apply
SELECT sID, 'Carnegie Mellon', 'EE', 'Y'
FROM Student
WHERE sID in (SELECT sID FROM Apply WHERE major = 'EE' AND Decision = 'N');

--Delete all students who applied to more than two majors
DELETE FROM Student
WHERE sID in
(SELECT sID
FROM Apply
GROUP BY sID
HAVING count(DISTINCT major) > 2);

--Delete colleges without CS applicants
DELETE FROM College
where cName not in (SELECT cName from Apply WHERE major = 'CS');

--Accept applicants to Carnegie Mellon with GPA < 3.6 and change them to econ major
UPDATE Apply
SET decision = 'Y', major = 'economics'
WHERE cName = 'Carnegie Mellon' AND sID in (SELECT sID FROM Student WHERE GPA < 3.6);

--Find student with highest GPA and have applied to EE and change major to CSE
Update Apply
SET major = 'CSE'
WHERE major = 'EE' AND
sID in (SELECT sID from Student WHERE GPA >= ALL (SELECT GPA FROM Student WHERE sID in (SELECT sID FROM Apply WHERE major = 'EE')));

UPDATE student
SET GPA = (SELECT max(GPA) FROM Student), sizeHS = (SELECt min(sizeHS) FROM Student);

UPDATE Apply
SET decision = 'Y';