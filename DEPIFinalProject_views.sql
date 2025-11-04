-- View 1: Shows employment status for people who took courses vs those who did not
 

CREATE VIEW vw_Demographics AS
SELECT
    d.PK,
    d.[النوع] AS Gender,
    d.[السن] AS Age,
    d.[الحالة الاجتماعية] AS SocialStatus,
    d.[المحافطة] AS Governorate
FROM Demographics d;



-- View 2: Shows relationship between taking courses and finding a job
CREATE VIEW vw_Courses_Employment AS
SELECT
    c.PK,
    c.[نوع الكورسات اللي أخدتها كان إيه؟] AS CoursesTaken,
    c.[بعد الكورسات، لقيت شغل؟] AS FoundJob
FROM Courses_job c;

-- View 3: Shows if internships helped in employment or personal skills
CREATE VIEW vw_Internships_Employment AS
SELECT
    s.PK,
    s.[خدت Internship قبل كده؟] AS TookInternship,
    s.[هل اللغات دي فادتك في الشغل؟] AS InternshipHelped
FROM [Soft_Skills_internships] s;

select * 
from Soft_Skills_internships

-- View 4: Shows soft skills and if they were useful in job opportunities
CREATE VIEW vw_SoftSkills_Summary AS
SELECT
    s.PK,
    s.[اللغات الي تعرفها؟] AS Languages,
    s.[هل اللغات دي فادتك في الشغل؟] AS LanguagesUsedInJob,
    s.[شاركت في أنشطة طلابية أو تطوع؟] AS StudentActivities,
    s.[لو أيوه هل فادتك في الشغل؟] AS SkillAndImpact
FROM [Soft_Skills_internships] s;



-- View 5: Shows education background for each participant
CREATE VIEW vw_Education_Summary AS
SELECT
    e.PK,
    e.[اتخرجت؟] AS Graduated,
    e.[الكلية او المعهد؟] AS UniversityOrInstitute,
    e.[المستوى التعليمي] AS EducationLevel
FROM Education e;


-- View 6: Shows expected/current salary and interview rejection reasons
CREATE VIEW vw_Salary_Insights AS
SELECT
    s.PK,
    s. [متوسط مرتبك الحالي او المتوقع بالمصري أو العملة الي بتبقبض بيها:]  AS ExpectedOrCurrentSalary,
    s.[لو دخلت  إنترفيوز و متقبلتش هل عارف سبب الرفض؟] AS RejectionReason
FROM Salary_interviews s;




-- Master View: Combines all tables into one unified dataset for full analysis
CREATE VIEW vw_Unemployment_Master AS
SELECT 
    d.PK,
    
    -- Demographics
    d.[النوع] AS Gender,
    d.[السن] AS Age,
    d.[الحالة الاجتماعية] AS SocialStatus,
    d.[المحافطة] AS Governorate,

    -- Education
    e.[اتخرجت؟] AS Graduated,
    e.[الكلية او المعهد؟] AS UniversityOrInstitute,
    e.[المستوى التعليمي] AS EducationLevel,

    -- Courses & Jobs
    c.[("لو "أيوه) الكورسات كانت إيه؟ ] AS CoursesTaken,
    c.[بعد الكورسات، لقيت شغل؟] AS FoundJob,

    -- Salary & Interviews
    si.[متوسط مرتبك الحالي او المتوقع بالمصري أو العملة الي بتبقبض بيها:] AS ExpectedOrCurrentSalary,
    si.[لو دخلت  إنترفيوز و متقبلتش هل عارف سبب الرفض؟] AS RejectionReason,

    -- Soft Skills & Internships
    s.[خدت Internship قبل كده؟] AS TookInternship,
    s.[لو أيوه فين ؟] AS InternshipHelped,
    s.[اللغات الي تعرفها؟] AS Languages,
    s.[هل اللغات دي فادتك في الشغل؟] AS LanguagesUsedInJob,
    s.[شاركت في أنشطة طلابية أو تطوع؟] AS StudentActivities,
    s.[هل عندك مهارة معينة؟ ولو آه، هل المهارة دي ساعدتك/قدّمتلك فرصة (زي شغل أو  تدريب أو نشاط)؟"] AS SkillAndImpact

FROM Demographics d
LEFT JOIN Education e ON d.PK = e.PK
LEFT JOIN Courses_job c ON d.PK = c.PK
LEFT JOIN Salary_interviews si ON d.PK = si.PK
LEFT JOIN [Soft_Skills_internships] s ON d.PK = s.PK;






-- Shows employment status for males vs females
CREATE VIEW vw_Employment_distribution_By_Gender AS
SELECT 
    Gender,
    FoundJob,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY Gender, FoundJob;



CREATE VIEW vw_Employment_By_Gender AS
SELECT 
    Gender,
    COUNT(*) AS TotalEmployed
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'نعم', N'أيوه', N'Yes')  
GROUP BY Gender;




-- Shows which governorates have the highest or lowest employment
CREATE VIEW vw_Employment_By_Governorate AS
SELECT 
    Governorate,
    FoundJob,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY Governorate, FoundJob;




CREATE VIEW vw_OnlyEmployment_By_Governorate AS
SELECT 
    Governorate,
    COUNT(*) AS TotalEmployed
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'نعم', N'أيوه', N'Yes')    
GROUP BY Governorate;




CREATE VIEW vw_UnEmployment_By_Governorate AS
SELECT 
    Governorate,
    COUNT(*) AS TotalUnemployed
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'لا', N'لأ', N'No')   
GROUP BY Governorate;






-- Shows if internships helped people get jobs
CREATE VIEW vw_Impact_Internships AS    -----> i didn't run that, DON'T run it
SELECT 
    TookInternship,
    FoundJob,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY TookInternship, FoundJob;





-- employment people number for those took internship and those who didn't

 
CREATE VIEW vw_employment_people_numbers_internship AS
SELECT 
    TookInternship,
    COUNT(*) AS TotalEmployed
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'نعم', N'أيوه', N'Yes')    
GROUP BY TookInternship;



-- employment precentage chance for those took internship and those who didn't

CREATE VIEW vw_employment_precentage_chance_internsship AS
SELECT 
    TookInternship,
    SUM(CASE WHEN FoundJob IN (N'نعم', N'أيوه', N'Yes') THEN 1 END) * 100.0 
        / COUNT(*) AS EmploymentPercentage
FROM vw_Unemployment_Master
GROUP BY TookInternship;





-- Shows if having skills or languages helped in job opportunities
CREATE VIEW vw_Skills_Impact AS  -----> i didn't run that
SELECT
    SkillAndImpact,
    LanguagesUsedInJob,
    FoundJob,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY SkillAndImpact, LanguagesUsedInJob, FoundJob;



CREATE VIEW vw_Skills_Impact AS
SELECT
    SkillAndImpact,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'نعم', N'أيوه', N'Yes')   -- change to your “employed” value
GROUP BY SkillAndImpact;




-- Shows if higher education leads to higher employment rates
CREATE VIEW vw_Education_Employment AS ----> didn't run that 
SELECT
    EducationLevel,
    FoundJob,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY EducationLevel, FoundJob;
   


CREATE VIEW vw_Education_Impact AS
SELECT
    EducationLevel,
    COUNT(*) AS TotalEmployed
FROM vw_Unemployment_Master
WHERE FoundJob IN (N'نعم', N'أيوه', N'Yes')    
GROUP BY EducationLevel;









-- Shows salary expectation patterns for employed vs unemployed
CREATE VIEW vw_Salary_Expectation_Employment AS
SELECT
    FoundJob,
    ExpectedOrCurrentSalary,
    COUNT(*) AS TotalPeople
FROM vw_Unemployment_Master
GROUP BY FoundJob, ExpectedOrCurrentSalary;


-- Shows if high salary expectations reduce job chances:  ---> we can use a filter for each job name
CREATE VIEW vw_Salary_Epectation_Impact AS
SELECT
    ExpectedOrCurrentSalary,
    ROUND(
        SUM(CASE WHEN FoundJob IN (N'نعم', N'أيوه', N'Yes') THEN 1 END) * 100.0
        / COUNT(*), 2
    ) AS EmploymentPercentage
FROM vw_Unemployment_Master
GROUP BY ExpectedOrCurrentSalary;




