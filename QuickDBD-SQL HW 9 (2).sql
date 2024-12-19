-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/CngbeH
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.




CREATE TABLE Titles (
    title_id VARCHAR(10)  NOT NULL ,
    title_name VARCHAR(30)  NOT NULL 
);

SELECT * FROM titles 


CREATE TABLE Salaries (
    emp_no INT  NOT NULL ,
    salary SERIAL  NOT NULL 
);

SELECT * FROM Salaries 


CREATE TABLE Department_Manager (
    dep_no VARCHAR(10)  NOT NULL ,
    emp_no INT  NOT NULL 
);

SELECT * FROM Department_Manager

CREATE TABLE Employees (
    emp_no INT  NOT NULL ,
    title_id VARCHAR(10)  NOT NULL ,
    birth_date VARCHAR(10)  NOT NULL ,
    first_name VARCHAR(30)  NOT NULL ,
    last_name VARCHAR(30)  NOT NULL ,
    sex VARCHAR(1)  NOT NULL ,
    hire_date DATE  NOT NULL 
	
);

SELECT * FROM Employees 


CREATE TABLE Department_Employees (
    emp_no INT  NOT NULL ,
   	dept_no VARCHAR(10)  NOT NULL 
);

SELECT * FROM Department_Employees

CREATE TABLE Departments (
    dept_no VARCHAR (10)  NOT NULL ,
   	dept_name VARCHAR(30)  NOT NULL 
);

SELECT * FROM Departments

-- CREATE TABLE THAT LISTS EMPLOYEE NUMBER,LAST NAME, FIRST NAME . SEX. SALARY
--STEP 1 JOIN TABLE SALARIES AND EMPLOYEES
SELECT 
    salaries.emp_no,
    employees.last_name,
    employees.first_name,
    employees.sex,
    salaries.salary
FROM salaries
JOIN employees ON salaries.emp_no = employees.emp_no
--SET ORDER OF HOW COLUMNS WILL BE LISTED
ORDER BY salaries.emp_no, 
employees.last_name, 
employees.first_name, 
employees.sex, 
salaries.salary;


--List the first name, last name, and hire date for the employees who were hired in 1986 
--STEP 1 

SELECT 
	employees.first_name,
 	employees.last_name,
 	employees.hire_date
FROM department_employees
JOIN employees ON department_employees.emp_no = employees.emp_no
WHERE employees.hire_date BETWEEN '1986-01-01' AND '1986-12-31'

--SET ORDER OF HOW COLUMNS WILL BE LISTED
ORDER BY 
 employees.hire_date;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name,
    employees.hire_date,
    titles.title_name
FROM departments
JOIN department_employees ON departments.dept_no = department_employees.dept_no
JOIN employees ON department_employees.emp_no = employees.emp_no
JOIN titles ON employees.title_id = titles.title_id
WHERE titles.title_id = 'm0001'
ORDER BY 
	titles.title_name,
    departments.dept_no,
    departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name
	
  FROM departments
JOIN department_employees ON departments.dept_no = department_employees.dept_no
JOIN employees ON department_employees.emp_no = employees.emp_no

ORDER BY 
department_employees.emp_no ASC;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.    
SELECT 
    departments.dept_no,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name,
    employees.sex
FROM departments
JOIN department_employees ON departments.dept_no = department_employees.dept_no
JOIN employees ON department_employees.emp_no = employees.emp_no
ORDER BY 
    CASE 
        WHEN employees.last_name = 'B' THEN 0 
        ELSE 1 
    END,
    CASE 
        WHEN employees.first_name = 'Hercules' THEN 0 
        ELSE 1 
    END,
	employees.first_name,
    employees.last_name;
    
--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name
	
FROM departments
JOIN department_employees ON departments.dept_no = department_employees.dept_no
JOIN employees ON department_employees.emp_no = employees.emp_no

WHERE 
departments.dept_name = 'Sales'
ORDER BY 
departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name;
--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name
	
FROM departments
JOIN department_employees ON departments.dept_no = department_employees.dept_no
JOIN employees ON department_employees.emp_no = employees.emp_no

WHERE 
departments.dept_name IN ('Sales', 'Development')
ORDER BY 
departments.dept_name,
    department_employees.emp_no,
    employees.last_name,
    employees.first_name;
--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT 
    last_name,
    COUNT(*) AS name_count
FROM 
    employees
GROUP BY 
    last_name
ORDER BY 
    name_count DESC
