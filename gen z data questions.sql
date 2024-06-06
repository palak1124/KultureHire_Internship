Use Genzdataset;
SHOW TABLES;

-- This is comment
/* joining tables */
WITH wholedata AS (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        m.MissionUndefinedLikelihood,
        m.MisalignedMissionLikelihood,
        m.NoSocialImpactLikelihood,
        m.LaidOffEmployees,
        m.ExpectedSalary3years,
        m.ExpectedSalary5years,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer,
        ma.WorkLikelihood3years,
        ma.PreferredEmployer,
        ma.PreferredManager,
        ma.PreferredWorksetup,
        ma.WorkLikelihood7Years
    FROM
        personalized_info AS p
    LEFT JOIN
        mission_aspirations AS m ON p.ResponseID = m.ResponseID
    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
    LEFT JOIN
        manager_aspirations AS ma ON p.ResponseID = ma.ResponseID
)
SELECT * FROM wholedata;

/* 1. How many Male have responded to the survey from India? */

SELECT  COUNT(ResponseID) 
from personalized_info where currentcountry = 'India' and Gender = 'Male';


/* 2. How many Females have responded to the survey from India?*/

SELECT COUNT(ResponseID) 
from personalized_info where currentcountry = 'India'  and Gender = 'Male';
 
 /* 3.  How many of the Female Gen-Z are influenced by their parents in regards to their carrer choices from India? */

SELECT Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India' and  CareerInfluenceFactor = 'My Parents' 
and gender = 'Female';
 /* 4. How many of the Male Gen- Z are influenced by their parents in regards to their Career choices in India? */
 SELECT Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India' and  CareerInfluenceFactor = 'My Parents' 
and gender = 'Male';

 /* 5.  How many of the Male and Female Gen-Z (individually display columns, but as part of the same query) Gen-Z are influenced by their parents in regard to their career choices from India ?*/
 
 SELECT Gender,Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India' and  CareerInfluenceFactor = 'My Parents' 
group by Gender;
 
 /* 6. How many Gen-Z are influenced by Media and Influencers together from India? */

 SELECT Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India' AND CareerInfluenceFactor in('Social Media like LinkedIn',
'Influencers who had successful careers');

/* 7. How many of the Gen-Z influenced by their parents in regards to their in regards to their career choices from India?    */
SELECT Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India'    and CareerInfluenceFactor = 'My Parents';

 /* 8. How many of the Gen- Z are influenced by Social Media and Influencers togerther, display for Male and Female separately from India ? */
 SELECT Gender,Count(ResponseID)
FROM (
    SELECT 
        p.ResponseID,
        p.CurrentCountry,
        p.ZipCode,
        p.Gender,
        l.CareerInfluenceFactor,
        l.HigherEducationAbroad,
        l.PreferredWorkingEnvironment,
        l.ZipCode AS LearningZipCode,
        l.ClosestAspirationalCareer
    FROM
        personalized_info AS p

    LEFT JOIN
        learning_aspirations AS l ON p.ResponseID = l.ResponseID
) wholedata
WHERE CurrentCountry = 'India' and  CareerInfluenceFactor in ('Influencers who had successful careers', 'Social Media like LinkedIn') 
group by Gender;
 /* 9. How many of the Gen- Z are influenced by Social Media for their Career aspiration to go abroad?*/
 Select count(ResponseID)
      from  learning_aspirations
        where CareerInfluenceFactor = 'Social Media like LinkedIn';
        
 /* 10.  How many of the Gen-G who are influenced by people in their circle for carrer aspiration are looking to go abroad?*/
   
   Select count(ResponseID)
      from  learning_aspirations
        where CareerInfluenceFactor = 'People from my circle, but not family members' 
        and HigherEducationAbroad = 'Yes, I wil';