create table tmp_intvw_company (
  company_id number(9),
  name varchar2(100) not null
);
insert into tmp_intvw_company (company_id, name) values (1, 'Company A');
insert into tmp_intvw_company (company_id, name) values (2, 'Company C');
insert into tmp_intvw_company (company_id, name) values (3, 'Company B');
insert into tmp_intvw_company (company_id, name) values (4, 'Company D');
commit;


create table tmp_intvw_plant (
  plant_id number(9),
  company_id number(9) not null,
  plant_name varchar2(100) not null
);
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (1, 2, 'Bayan Lepas Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (2, 2, 'George Town Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (3, 1, 'Ipoh Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (4, 1, 'Taiping Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (5, 1, 'Kampar Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (6, 4, 'Johor Bahru Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (7, 3, 'Kepong Plant');
insert into tmp_intvw_plant (plant_id, company_id, plant_name) values (8, 3, 'Cheras Plant');
commit;


create table tmp_intvw_employee (
  employee_id number(9) ,
  plant_id number(9) not null,  
  name varchar(30) not null,  
  age number(18,2) ,
  department varchar(30) ,
  salary number(18,2) ,
  hired_date date 
);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (1, 2, 'Sharon', 30, 'IT', 2500);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (2, 4, 'Halim', 45, 'HR', 6500);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (3, 8, 'Wong Tan Meng', 50, 'IE', 5500);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (4, 4, 'Steven', 28, 'IT', 2600);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (5, 7, 'Hazim', 38, 'IE', 4757);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (6, 8, 'Chang Xi Loong', 54, 'PE', 6036);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (7, 3, 'Mike', 47, 'IT', 5697);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (8, 4, 'Helen', 26, 'PE', 2356);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (9, 1, 'Shah', 38, 'HR', 3964);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (10, 1, 'Foong', 45, 'IT', 8888);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (11, 3, 'Shawn', 36, 'IT', 9999);
insert into tmp_intvw_employee (employee_id, plant_id, name, age, department, salary ) values (12, 2, 'Eric', 31, 'IT', 2888);

-- Answer no 1

SELECT 
    e.department AS DEPARTMENT,
    e.name AS NAME,
    e.age AS AGE,
    p.plant_name AS PLANT_NAME,
    c.name AS COMPANY_NAME,
    'RM' || TO_CHAR(e.salary, '9999.99') AS SALARY
FROM 
    tmp_intvw_employee e
JOIN 
    tmp_intvw_plant p ON e.plant_id = p.plant_id
JOIN 
    tmp_intvw_company c ON p.company_id = c.company_id
ORDER BY 
    e.department, e.name;

-- Answer no 2

SELECT 
    c.name AS NAME,
    e.department AS DEPARTMENT,
    COUNT(*) AS TOTAL_EMPLOYEE
FROM 
    tmp_intvw_employee e
JOIN 
    tmp_intvw_plant p ON e.plant_id = p.plant_id
JOIN 
    tmp_intvw_company c ON p.company_id = c.company_id
GROUP BY 
    c.name, e.department
ORDER BY 
    c.name, e.department;

-- Answer no 3

SELECT
  CASE
    WHEN salary BETWEEN 2001 AND 3000 THEN '2001–3000'
    WHEN salary BETWEEN 3001 AND 5000 THEN '3001–5000'
    WHEN salary > 5000 THEN 'More than 5000'
  END AS SALARY_RANGE,
  COUNT(*) AS TOTAL_EMPLOYEE
FROM
  tmp_intvw_employee
WHERE
  salary > 2000
GROUP BY
  CASE
    WHEN salary BETWEEN 2001 AND 3000 THEN '2001–3000'
    WHEN salary BETWEEN 3001 AND 5000 THEN '3001–5000'
    WHEN salary > 5000 THEN 'More than 5000'
  END
ORDER BY
  SALARY_RANGE;


-- Answer no 4
-- Need to use Union then NVL (set default value if null) to get the 0 value data in the first row

SELECT sr.salary_range,
       NVL(emp.total_employee, 0) AS total_employee
FROM ( 
    SELECT 'Below 2000' AS salary_range, 1 AS sort_order FROM dual
    UNION ALL
    SELECT '2001–3000', 2 FROM dual
    UNION ALL
    SELECT '3001–5000', 3 FROM dual
    UNION ALL
    SELECT 'More than 5000', 4 FROM dual
) sr
LEFT JOIN (
    SELECT CASE
             WHEN salary < 2000 THEN 'Below 2000'
             WHEN salary BETWEEN 2001 AND 3000 THEN '2001–3000'
             WHEN salary BETWEEN 3001 AND 5000 THEN '3001–5000'
             WHEN salary > 5000 THEN 'More than 5000'
           END AS salary_range,
           COUNT(*) AS total_employee
    FROM tmp_intvw_employee
    GROUP BY
      CASE
        WHEN salary < 2000 THEN 'Below 2000'
        WHEN salary BETWEEN 2001 AND 3000 THEN '2001–3000'
        WHEN salary BETWEEN 3001 AND 5000 THEN '3001–5000'
        WHEN salary > 5000 THEN 'More than 5000'
      END
) emp ON sr.salary_range = emp.salary_range
ORDER BY sr.sort_order;

