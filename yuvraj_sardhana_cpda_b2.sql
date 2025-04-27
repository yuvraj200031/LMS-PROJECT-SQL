USE lms;
#Retrieve a list of courses along with the name of the category to which each course belongs
SELECT courses.course_name, categories.category_name
FROM courses
JOIN categories ON courses.category_id = categories.category_id;

#For each category, count how many courses exist.
SELECT categories.category_name, COUNT(courses.category_id) AS 	course_count
FROM categories
LEFT JOIN courses ON categories.category_id = courses.category_id
GROUP BY categories.category_name;

#Retrieve the full names and email addresses for all users with the role 'student. '
SELECT first_name , last_name , email
FROM user 
WHERE role = 'student';

#For a given course (e.g., course_id = 1), list its modules sorted by their order.
SELECT module_id, module_name, module_order
FROM modules
WHERE course_id = 1
ORDER BY module_order ASC;

#Retrieve all content items for a specific module (for example, module_id = 2).
SELECT content_id, title, content_type, url
FROM content
WHERE module_id = 2;

#Calculate the average score of submissions for a given assessment
SELECT assessment_id, AVG(score) AS average_score
FROM assessment_submission
WHERE assessment_id = 1;

#List the full names and email addresses of all users with the role 'instructor'.
SELECT first_name, last_name, email
FROM user
WHERE role = 'instructor';

#For each assessment, count how many submissions have been made.
SELECT assessment_id, COUNT(submission_id) AS submission_count
FROM assessment_submission
GROUP BY assessment_id;

#Retrieve, for each assessment, the submission that achieved the highest score.
SELECT assessment_id, submission_id, user_id, score
FROM assessment_submission as a1
WHERE score = (SELECT MAX(score) FROM assessment_submission AS a2 WHERE a2.assessment_id = a1.assessment_id);

#List courses that were created after '2023-04-01'.
SELECT course_id, course_name, created_at
FROM courses
WHERE created_at > '2023-04-01';

#Retrieve a list of students who do not have any records in the assessment_submission table.
SELECT u.first_name, u.last_name, u.email
FROM user AS u
LEFT JOIN assessment_submission AS a ON u.user_id = a.user_id
WHERE u.role = 'student' AND a.submission_id IS NULL;

#Retrieve all content items for courses whose category is 'Programming
SELECT content.content_id, content.title, content.content_type, content.url
FROM content
INNER JOIN modules ON content.module_id = modules.module_id
INNER JOIN courses ON modules.course_id = courses.course_id
INNER JOIN categories ON courses.category_id = categories.category_id
WHERE categories.category_name = 'Programming';

#List modules that do not have any content items linked to them.
SELECT modules.module_id, modules.module_name
FROM modules
LEFT JOIN content ON modules.module_id = content.module_id
WHERE content.content_id IS NULL;

#For each course, display the course name along with the count of enrollments.
SELECT c.course_name, COUNT(e.user_id) AS enrollment_count
FROM courses AS c LEFT JOIN enrollments AS e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

#Find the Average Assessment Submission Score for Each Course
SELECT c.course_name, AVG(as1.score) AS average_submission_score
FROM assessment_submission AS as1
INNER JOIN assessments AS a ON as1.assessment_id = a.assessment_id
INNER JOIN modules AS m ON a.module_id = m.module_id
INNER JOIN courses AS c ON m.course_id = c.course_id
GROUP BY c.course_id, c.course_name;

#Retrieve a list of all users along with the count of courses they are enrolled in.
SELECT u.user_id, u.first_name, u.last_name, u.email, COUNT(e.course_id) AS enrolled_courses_count
FROM user  AS u
LEFT JOIN enrollmentS AS e ON u.user_id = e.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email;
    
#Identify the assessment that has the highest average submission score
SELECT assessment_id, AVG(score) AS average_score
FROM assessment_submission
GROUP BY assessment_id
ORDER BY average_score DESC;

#Retrieve a hierarchical list that shows each course, its modules, and the content items within each module.
SELECT c.course_name, m.module_name, co.title AS content_title, co.content_type
FROM courses AS c
INNER JOIN modules AS m ON c.course_id = m.course_id
INNER JOIN content AS co ON m.module_id = co.module_id
ORDER BY c.course_name, m.module_order, co.title;
    
#For each course, count the total number of assessments available by joining courses, modules, and assessments.
SELECT c.course_name, COUNT(a.assessment_id) AS total_assessments
FROM courses AS c
INNER JOIN modules AS m ON c.course_id = m.course_id
INNER JOIN assessments AS a ON m.module_id = a.module_id
GROUP BY c.course_id, c.course_name;

#Retrieve all enrollment records where the enrollment date falls within May 2023.
SELECT enrollment_id, user_id, course_id, enrolled_at
FROM enrollments
WHERE enrolled_at >= '2023-05-01' AND enrolled_at < '2023-06-01';

#For each assessment submission, display the submission details along with the corresponding course name, student name, and assessment name.
SELECT a_sub.submission_id, a_sub.submitted_at, a_sub.score, c.course_name, u.first_name, u.last_name, a.assessment_name
FROM assessment_submission AS a_sub
INNER JOIN assessments AS a ON a_sub.assessment_id = a.assessment_id
INNER JOIN modules AS m ON a.module_id = m.module_id
INNER JOIN courses AS c ON m.course_id = c.course_id
INNER JOIN user AS u ON a_sub.user_id = u.user_id
ORDER BY a_sub.submitted_at DESC;

#Retrieve a list of all users showing their full names and roles.
SELECT first_name , last_name , role
FROM user;

#List the courses for which there are no enrollment records.
SELECT c.course_id, c.course_name
FROM courses AS c
JOIN enrollments AS e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;
