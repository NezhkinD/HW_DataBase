WITH RECURSIVE Subworkers AS (SELECT employees.EmployeeID,
                                     employees.Name,
                                     employees.ManagerID,
                                     employees.DepartmentID,
                                     employees.RoleID
                              FROM org.Employees employees
                              WHERE employees.EmployeeID = 1

                              UNION ALL

                              SELECT employees.EmployeeID,
                                     employees.Name,
                                     employees.ManagerID,
                                     employees.DepartmentID,
                                     employees.RoleID
                              FROM org.Employees employees
                                       INNER JOIN Subworkers s ON employees.ManagerID = s.EmployeeID)

SELECT subworkers.EmployeeID                           as "EmployeeID",
       subworkers.Name                                 AS "EmployeeName",
       subworkers.ManagerID                            as "ManagerID",
       departments.DepartmentName                      as "DepartmentName",
       roles.RoleName                                  as "RoleName",
       STRING_AGG(DISTINCT projects.ProjectName, ', ') AS "ProjectNames",
       STRING_AGG(DISTINCT tasks.TaskName, ', ')       AS "TaskNames"
FROM Subworkers subworkers
         LEFT JOIN org.Departments departments ON subworkers.DepartmentID = departments.DepartmentID
         LEFT JOIN org.Roles roles ON subworkers.RoleID = roles.RoleID
         LEFT JOIN org.Tasks tasks ON subworkers.EmployeeID = tasks.AssignedTo
         LEFT JOIN org.Projects projects ON projects.DepartmentID = departments.DepartmentID
GROUP BY subworkers.EmployeeID,
         subworkers.Name,
         subworkers.ManagerID,
         departments.DepartmentName,
         roles.RoleName
ORDER BY subworkers.Name ASC;