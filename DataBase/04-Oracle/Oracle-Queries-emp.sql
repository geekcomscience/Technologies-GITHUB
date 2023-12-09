SELECT * FROM emp_1221208;
SELECT * FROM dept_1221208;

--Analytical function. assing sum of salary to each record.
select fname, departmentid, salary, SUM(salary) OVER() from emp_1221208;

--Analytical function. assing sum of salary to each record by department id.
select fname, departmentid, salary, SUM(salary) OVER(PARTITION BY departmentid) as invbydept from emp_1221208;


--------------------------------- ANALYTICAL FUNCTION scenario 1 --------------------------------------------
--Get the total investment for employees in Emp table?
select sum(salary) from emp_1221208;

--Get the employee name, salary and dept number for all employees in Emp table?
select fname, salary, departmentid from emp_1221208;


-- Get the employee name, salary, dept number and total investment made for all employees in Emp table?

-- Approach 1: using join
select fname, salary, departmentid, totalsalary from emp_1221208 e, (select sum(salary) as totalsalary from emp_1221208) ts;

-- Approach 2: using single row query
select fname, salary, departmentid, (select sum(salary) from emp_1221208) as totalsalary from emp_1221208;


-- Approach 3: using analytical funcitons
select fname, salary departmentid, sum(salary) OVER() as totalsalary from emp_1221208;

------------------------------------------------------ ANALYTICAL FUNCTION scenarion 1----------------------------------------------------------------------------------

----------------------------------------------------------------------------- JOIN START -----------------------------------------------------------------------------------------------------
SELECT * FROM emp_1221208;
SELECT * FROM dept_1221208;
SELECT * FROM cust_1221208;
SELECT * FROM cars_1221208;

  
select e.id, e.fname,e.salary,d.id as deptid,d.name deptname
from emp_1221208 e, dept_1221208 d
where e.departmentid = d.id -- join condition
order by e.id;

select e.id, e.fname,e.salary,d.id as deptid,d.name deptname
from emp_1221208 e, dept_1221208 d
where e.departmentid=1 and d.name='HR';


------ Write a SQL query to get the employee name, Salary, designation, department number, department name and location for all managers working in “SALES” department?

select e.fname, e.salary, e.managerid, d.id as deptid, d.name as deptname
from emp_1221208 e, dept_1221208 d
where e.departmentid = d.id  and e.managerid = 1 and d.name = 'Sales';

select e.fname, e.salary, e.managerid, d.id as deptid, d.name as deptname
from emp_1221208 e, dept_1221208 d;
 
 
-- Find the employees name, salary, designation and their manager’s name, salary and designation for all employees who are earning more than their managers?


--Get the details of all departments and employees working in each department?
select nvl(e.fname,'no employees') as employeename, d.name as deptname, d.id as deptid
from emp_1221208 e, dept_1221208 d
where e.departmentid (+) = d.id
order by deptid;



--- INNER JOIN
SELECT * FROM emp_1221208;
SELECT * FROM dept_1221208;


select e.fname, e.salary,d.id,d.name
from emp_1221208 e
INNER JOIN dept_1221208 d ON e.departmentid = d.id;

--- NATURAL JOIN
select e.fname, e.salary, d.id,d.name
from emp_1221208 e
Natural join dept_1221208 d;

------------------------------------------------------------------------ JOIN END -----------------------------------------------------------------------------------------------------

------------------------------------------------------------------------ SUB QUERY ----------------------------------------------------------------------------------------------------
--Get the details of the employees with their department number, salary and their department’s average salary?


select e.fname,e.departmentid, e.salary,b.avgSal
from emp_1221208 e, (select departmentid, ceil(avg(salary)) as avgSal
from emp_1221208
group by departmentid) b
where e.departmentid=b.departmentid;

-- Get the details of the employees with their department number, salary and their department’s average salary and also the difference between their salary and average salary of their department?

select e.fname,e.departmentid, e.salary,b.avgSal, ( e.salary-b.avgSal) as diffSal
from emp_1221208 e, (select departmentid, ceil(avg(salary)) as avgSal
from emp_1221208
group by departmentid) b
where e.departmentid=b.departmentid;

--Get the department number, department name and total number of employees for only those departments in which number of employees recruited in the department is greater than 2?

select d.id,d.name,ve.numOfEmployess
from dept_1221208 d, (select departmentid, count(*) as numOfEmployess from emp_1221208 group by departmentid) ve
where d.id=ve.departmentid and numOfEmployess > 2;

select d.id,d.name,ve.numOfEmployess
from dept_1221208 d, (select departmentid, count(*) as numOfEmployess from emp_1221208 group by departmentid having  count(*) > 2) ve
where d.id=ve.departmentid;

------------------------------------------------------------------------ SUB QUERY ----------------------------------------------------------------------------------------------------

