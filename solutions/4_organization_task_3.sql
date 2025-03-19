WITH RECURSIVE
    Subworkers AS (SELECT employees.EmployeeID,
                          employees.Name,
                          employees.ManagerID,
                          employees.DepartmentID,
                          employees.RoleID
                   FROM org.Employees employees
                   WHERE employees.RoleID = 1

                   UNION ALL

                   SELECT employees.EmployeeID,
                          employees.Name,
                          employees.ManagerID,
                          employees.DepartmentID,
                          employees.RoleID
                   FROM org.Employees employees
                            INNER JOIN Subworkers s ON employees.ManagerID = s.EmployeeID),

    SubworkersCount AS (SELECT subworkers_1.EmployeeID                 AS ManagerID,
                               COUNT(DISTINCT subworkers_2.EmployeeID) AS total_subordinates
                        FROM Subworkers subworkers_1
                                 LEFT JOIN Subworkers subworkers_2
                                           ON subworkers_2.ManagerID = subworkers_1.EmployeeID OR
                                              subworkers_2.EmployeeID IN
                                              (WITH RECURSIVE SubTree AS (SELECT EmployeeID, ManagerID
                                                                          FROM org.Employees
                                                                          WHERE ManagerID = subworkers_1.EmployeeID
                                                                          UNION ALL
                                                                          SELECT e.EmployeeID, e.ManagerID
                                                                          FROM org.Employees e
                                                                                   INNER JOIN SubTree st ON e.ManagerID = st.EmployeeID)
                                               SELECT EmployeeID
                                               FROM SubTree)
                        WHERE subworkers_1.RoleID = 1
                        GROUP BY subworkers_1.EmployeeID
                        HAVING COUNT(DISTINCT subworkers_2.EmployeeID) > 0)

SELECT employees.EmployeeID                            as "EmployeeID",
       employees.Name                                  AS "EmployeeName",
       employees.ManagerID                             AS "ManagerID",
       departments.DepartmentName                      AS "DepartmentName",
       roles.RoleName                                  AS "RoleName",
       STRING_AGG(DISTINCT projects.ProjectName, ', ') AS "ProjectNames",
       STRING_AGG(DISTINCT tasks.TaskName, ', ')       AS "TaskNames",
       subordinate_count.total_subordinates            AS "TotalSubordinates"
FROM org.Employees employees
         JOIN SubworkersCount subordinate_count ON employees.EmployeeID = subordinate_count.ManagerID
         LEFT JOIN org.Departments departments ON employees.DepartmentID = departments.DepartmentID
         LEFT JOIN org.Roles roles ON employees.RoleID = roles.RoleID
         LEFT JOIN org.Tasks tasks ON employees.EmployeeID = tasks.AssignedTo
         LEFT JOIN org.Projects projects ON tasks.ProjectID = projects.ProjectID
GROUP BY employees.EmployeeID,
         employees.Name,
         employees.ManagerID,
         departments.DepartmentName,
         roles.RoleName,
         subordinate_count.total_subordinates
ORDER BY employees.Name ASC;