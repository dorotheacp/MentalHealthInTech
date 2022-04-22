-- Data Cleaning & Preparation
-- Dataset from: https://www.kaggle.com/datasets/anth7310/mental-health-in-the-tech-industry

SELECT * FROM MentalHealth..Survey
SELECT * FROM MentalHealth..Question
SELECT * FROM MentalHealth..Answer

ALTER TABLE MentalHealth..Answer
ALTER COLUMN AnswerText nvarchar(max)
-------------------------------------------------------------------------------------
-- All Survey Questions
SELECT * FROM MentalHealth..Question

-- Total Respondents Each Year
SELECT SurveyID AS Year, COUNT(DISTINCT UserID) AS RespondentsCount
FROM MentalHealth..Answer
GROUP BY SurveyID
ORDER BY Year

-------------------------------------------------------------------------------------
--- Age of Respondents
-- Distribution of all answers
SELECT CAST(AnswerText AS int) AS Age
FROM MentalHealth..Answer
WHERE QuestionID = 1
--	  AND (CAST(AnswerText AS int) < 15
--	  OR CAST(AnswerText AS int) > 64)

SELECT CAST(AnswerText AS int) AS Age, 
	   COUNT(CAST(AnswerText AS int)) AS AgeCount
FROM MentalHealth..Answer
WHERE QuestionID = 1
GROUP BY CAST(AnswerText AS int)
ORDER BY 1 ASC

-- delete non working age (working age = 15 to 64)
DELETE FROM MentalHealth..Answer
WHERE QuestionID = 1
	  AND (CAST(AnswerText AS int) < 15
	  OR CAST(AnswerText AS int) > 64)

-------------------------------------------------------------------------------------
--- Gender of Respondents
-- see all answers
SELECT AnswerText
FROM MentalHealth..Answer
WHERE QuestionID = 2

-- distribution of all answers
SELECT AnswerText AS Gender, 
	   COUNT(AnswerText) AS GenderCount
FROM MentalHealth..Answer
WHERE QuestionID = 2 -- AND SurveyID = 2017
GROUP BY AnswerText

-- clean & update gender answers (female, male, other)
SELECT AnswerText,
	CASE WHEN AnswerText LIKE '%Female%' THEN 'Female'
		 WHEN AnswerText LIKE '%Male%' THEN 'Male'
		 ELSE 'Other'
	END
FROM MentalHealth..Answer
WHERE QuestionID = 2

UPDATE MentalHealth..Answer
SET AnswerText = CASE WHEN AnswerText LIKE '%Female%' THEN 'Female'
					  WHEN AnswerText LIKE '%Male%' THEN 'Male'
					  ELSE 'Other'
					  END
WHERE QuestionID = 2

--------------------------------------------------------------------------------------
--- Country 
-- All answers
SELECT AnswerText AS Country, 
	   COUNT(AnswerText) AS CountryCount
FROM MentalHealth..Answer
WHERE QuestionID = 3
GROUP BY AnswerText
ORDER BY 2 DESC

UPDATE MentalHealth..Answer
SET AnswerText = CASE WHEN AnswerText LIKE '%United States%' THEN 'United States of America'
					  WHEN AnswerText LIKE '%-1%' THEN 'Other'
					  WHEN AnswerText LIKE '%Unknown%' THEN 'Other'
					  ELSE AnswerText
					  END
WHERE QuestionID = 3

--------------------------------------------------------------------------------------
--- Questions about mental health diagnoses
SELECT *
FROM MentalHealth..Question
WHERE QuestionID = 32 OR QuestionID = 33 OR QuestionID = 34

--SELECT *
--FROM MentalHealth..Answer ans
--JOIN MentalHealth..Question que
--	ON ans.QuestionID = que.QuestionID
--WHERE ans.QuestionID = 32

-- Have you had a mental health disorder in the past?
SELECT AnswerText AS Past, 
	   COUNT(AnswerText) AS Past
FROM MentalHealth..Answer
WHERE QuestionID = 32
GROUP BY AnswerText
ORDER BY 2 DESC

UPDATE MentalHealth..Answer
SET AnswerText = CASE WHEN AnswerText LIKE '%-1%' THEN 'Don''t Know'
					  ELSE AnswerText
					  END
WHERE QuestionID = 32

-- Do you currently have a mental health disorder?
SELECT AnswerText AS Past, 
	   COUNT(AnswerText) AS Past
FROM MentalHealth..Answer
WHERE QuestionID = 33
GROUP BY AnswerText
ORDER BY 2 DESC

-- Have you ever been diagnosed with a mental health disorder?
SELECT AnswerText AS Past, 
	   COUNT(AnswerText) AS Past
FROM MentalHealth..Answer
WHERE QuestionID = 34
GROUP BY AnswerText
ORDER BY 2 DESC

UPDATE MentalHealth..Answer
SET AnswerText = CASE WHEN AnswerText LIKE '%-1%' THEN 'Not sure'
					  ELSE AnswerText
					  END
WHERE QuestionID = 34

--------------------------------------------------------------------------------------
