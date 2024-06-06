use Genzdataset;
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
/* 1. What percentage of male and female Genz wants to go to office Every Day ?*/
SELECT
    Gender, 
    ROUND(SUM(CASE WHEN PreferredWorkingEnvironment = 'Every Day Office Environment' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Percentage_EveryDay
FROM
personalized_info as p  left join  learning_aspirations as l on p.ResponseID = l.ResponseID 
    GROUP BY
    Gender;

        
	/* 2. What percentage of Genz's who have chosen their career in Business operations are most likely to be influenced by their Parents?*/
    SELECT
    Gender,
    COUNT(*) AS Total,
    ROUND(SUM(CASE WHEN ClosestAspirationalCareer LIKE 'Business Operations%' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS CareerPercentage
FROM
    personalized_info AS p
    LEFT JOIN learning_aspirations AS l ON p.ResponseID = l.ResponseID
WHERE
    CareerInfluenceFactor = 'My Parents'
GROUP BY
    Gender;
    

    /* 3.  What percentage of Genz prefer opting for higher studies, give a gender wise approach? */
    SELECT
    Gender,
    COUNT(*) AS Total,
    ROUND(SUM(CASE WHEN  HigherEducationAbroad = 'Yes, I wil' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS CareerPercentage
FROM
    personalized_info AS p
    LEFT JOIN learning_aspirations AS l ON p.ResponseID = l.ResponseID
GROUP BY
    Gender;

	/* 4.  What percentage of Genz are willing &amp; not willing to work for a company whose mission is misaligned with their public actions or even their products ? (give gender based split) */
	 Select  
     Gender,
    ROUND(SUM(CASE WHEN MisalignedMissionLikelihood  = 'Will work for them' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Percentage_Willing,
    ROUND(SUM(CASE WHEN MisalignedMissionLikelihood  = 'Will NOT work for them' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Percentage_NotWilling
     from personalized_info as p 
     left join mission_aspirations as m on p.ResponseID = m.ResponseID
          group by Gender;
    /* 5. What is the most suitable working environment according to female genz's?*/
    
     SELECT
    COUNT(p.ResponseID) AS Count,
    l.PreferredWorkingEnvironment
FROM
    personalized_info AS p 
    LEFT JOIN learning_aspirations AS l ON p.ResponseID = l.ResponseID  
WHERE
    Gender = 'Female'
GROUP BY
    Gender, l.PreferredWorkingEnvironment;

	/* 6. Calculate the total number of Female who aspire to work in their Closest Aspirational Career and have a No Social Impact Likelihood of "1 to 5" */

SELECT
    COUNT(p.ResponseID) AS TotalFemale
FROM
    personalized_info AS p
    LEFT JOIN learning_aspirations AS l ON p.ResponseID = l.ResponseID left	join mission_aspirations as m on p.ResponseID = m.ResponseID
WHERE
        p.Gender = 'Female'
AND  l.ClosestAspirationalCareer IS NOT NULL -- Assuming this column is not nullable
    AND m.NoSocialImpactLikelihood BETWEEN 1 AND 5;

	/* 7. Retrieve the Male who are interested in Higher Education Abroad and have a Career Influence Factor of "My Parents." */
   Select count(*) as Total_Male from personalized_info as p 
   left join learning_aspirations as l on p.ResponseID = l.ResponseID
   WHERE HigherEducationAbroad = 'Yes, I wil'AND CareerInfluenceFactor = 'My Parents'AND Gender = 'Male';
   
	/* 8.Determine the percentage of gender who have a No Social Impact Likelihood of "8 to 10" among those who are interested in Higher Education Abroad */
	 
     select   Gender, 
    ROUND(SUM(CASE WHEN HigherEducationAbroad = 'Yes, I wil' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Percentage_EveryDay
from personalized_info as p left join learning_aspirations as l on p.ResponseID = l.ResponseID 
left join mission_aspirations as m on p.ResponseID = m.ResponseID
     where  m.NoSocialImpactLikelihood BETWEEN 8 AND 10 group  by Gender;
     
    /* 9. Give a detailed split of the GenZ preferences to work with Teams, Data should include Male, Female and Overall in counts and also the overall in % */
	       SELECT
    Gender,
    COUNT(*) AS Total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM
    personalized_info AS p
LEFT JOIN
    manager_aspirations AS ma ON p.ResponseID = ma.ResponseID
WHERE
    ma.PreferredWorkSetup <> 'Work alone'
GROUP BY
    Gender
WITH ROLLUP;

            

/* 10. Give a detailed breakdown of "WorkLikelihood3Years" for each gender */
    
    Select Gender, count(WorkLikelihood3Years)
    from personalized_info as p left join 
    manager_aspirations as ma on p.ResponseID = ma.ResponseID
    where ma.WorkLikelihood3Years = 'Will work for 3 years or more' 
    group  by Gender ;
    
	/* 11. What is the Average Starting salary expectations at 3 year mark for each gender*/
    SELECT
    Gender,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(m.ExpectedSalary3Years, ' to ', 1), 'k', 1) 
            AS DECIMAL(10, 2)
        )
    ) AS AverageStartingSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    m.ExpectedSalary3Years IS NOT NULL
    AND m.ExpectedSalary3Years <> 'Not Applicable' -- Adjust if necessary
GROUP BY
    Gender;

    
	/* 12. What is the Average Starting salary expectations at 5 year mark for each gender */
    
     select Gender, avg(ExpectedSalary5Years) as Expected_Higher_Bar_Salary_5yr
    from personalized_info as p left join 
    mission_aspirations as l  on p.ResponseID = l.ResponseID 
 group  by Gender;
 
	/* 13. What is the Average Higher Bar salary expectations at 3 year mark for each gender*/
  
  select Gender, avg(ExpectedSalary3Years) as Expected_Higher_Bar_Salary_3yr
    from personalized_info as p left join 
    mission_aspirations as l  on p.ResponseID = l.ResponseID 
 group  by Gender;
 
	/* 14. What is the Average Higher Bar salary expectations at 5 year mark for each gender*/
    SELECT
    Gender,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, ' to ', -1), 'k', 1) 
            AS DECIMAL(10,2)
        )
    ) AS AverageHigherBarSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    ExpectedSalary5Years IS NOT NULL
    AND m.ExpectedSalary5Years IS NOT NULL
GROUP BY
    Gender;

	/* 15. What is the Average Starting salary expectations at 3 year mark for each gender and each state in India*/
    SELECT
    Gender,
    ZipCode AS State,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(m.ExpectedSalary3Years, ' to ', 1), 'k', 1) 
            AS DECIMAL(10,2)
        )
    ) AS AverageStartingSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    m.ExpectedSalary3Years IS NOT NULL
    AND m.ExpectedSalary3Years <> 'Not Applicable' -- Adjust if necessary
    AND p.CurrentCountry = 'India'
GROUP BY
    Gender, ZipCode;

    
	/* 16. What is the Average Starting salary expectations at 5 year mark for each gender and each state in India */
    SELECT
    Gender,
    ZipCode AS State,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(m.ExpectedSalary5Years, ' to ', 1), 'k', 1) 
            AS DECIMAL(10,2)
        )
    ) AS AverageStartingSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    m.ExpectedSalary5Years IS NOT NULL
    AND m.ExpectedSalary5Years <> 'Not Applicable' -- Adjust if necessary
    AND p.CurrentCountry = 'India'
GROUP BY
    Gender, ZipCode;


	/* 17. What is the Average Higher Bar salary expectations at 3 year mark for each gender and each state in India */
    SELECT
    Gender,
    ZipCode AS State,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(m.ExpectedSalary3Years, ' to ', -1), 'k', 1) 
            AS DECIMAL(10,2)
        )
    ) AS AverageHigherBarSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    m.ExpectedSalary3Years IS NOT NULL
    AND m.ExpectedSalary3Years <> 'Not Applicable' -- Adjust if necessary
    AND p.CurrentCountry = 'India'
GROUP BY
    Gender, ZipCode;

	/* 18. What is the Average Higher Bar salary expectations at 5 year mark for each gender and each state in India */
    SELECT
    Gender,
    ZipCode AS State,
    AVG(
        CAST(
            SUBSTRING_INDEX(SUBSTRING_INDEX(m.ExpectedSalary5Years, ' to ', -1), 'k', 1) 
            AS DECIMAL(10,2)
        )
    ) AS AverageHigherBarSalary
FROM
    personalized_info AS p
LEFT JOIN
    mission_aspirations AS m ON p.ResponseID = m.ResponseID
WHERE
    m.ExpectedSalary5Years IS NOT NULL
    AND m.ExpectedSalary5Years <> 'Not Applicable' -- Adjust if necessary
    AND p.CurrentCountry = 'India'
GROUP BY
    Gender, ZipCode;

	/*19. Give a detailed breakdown of the possibility of GenZ working for an Org if the "Mission is misaligned" for each state in India */
select ZipCode as State , count(*) as will_work FROM personalized_info as p left join mission_aspirations as m on
p.ResponseID = m.ResponseID 
WHERE MisalignedMissionLikelihood =  'Will work for them' group by ZipCode ;