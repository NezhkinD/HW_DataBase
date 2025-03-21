WITH RECURSIVE
    Subworkers AS (SELECT employees.EmployeeID,
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
                            INNER JOIN Subworkers s ON employees.ManagerID = s.EmployeeID),
    TotalTasks AS (SELECT tasks.AssignedTo    AS EmployeeID,
                          COUNT(tasks.TaskID) AS TotalTasks
                   FROM org.Tasks tasks
                   GROUP BY tasks.AssignedTo),
    TotalSubordinates AS (SELECT employees.ManagerID         AS EmployeeID,
                                 COUNT(employees.EmployeeID) AS TotalSubordinates
                          FROM org.Employees employees
                          GROUP BY employees.ManagerID)
SELECT subworkers.EmployeeID                             AS "EmployeeID",
       subworkers.Name                                   AS "EmployeeName",
       subworkers.ManagerID                              AS "ManagerID",
       departments.DepartmentName                        AS "DepartmentName",
       roles.RoleName                                    AS "RoleName",
       STRING_AGG(DISTINCT projects.ProjectName, ', ')   AS "ProjectNames",
       STRING_AGG(DISTINCT tasks.TaskName, ', ')         AS "TaskNames",
       COALESCE(total_tasks.TotalTasks, 0)               AS "TotalTasks",
       COALESCE(total_subordinates.TotalSubordinates, 0) AS "TotalSubordinates"
FROM Subworkers subworkers
         LEFT JOIN org.Departments departments ON subworkers.DepartmentID = departments.DepartmentID
         LEFT JOIN org.Roles roles ON subworkers.RoleID = roles.RoleID
         LEFT JOIN org.Tasks tasks ON subworkers.EmployeeID = tasks.AssignedTo
         LEFT JOIN org.Projects projects ON projects.DepartmentID = departments.DepartmentID
         LEFT JOIN TotalTasks total_tasks ON subworkers.EmployeeID = total_tasks.EmployeeID
         LEFT JOIN TotalSubordinates total_subordinates ON subworkers.EmployeeID = total_subordinates.EmployeeID
GROUP BY subworkers.EmployeeID,
         subworkers.Name,
         subworkers.ManagerID,
         departments.DepartmentName,
         roles.RoleName,
         total_tasks.TotalTasks,
         total_subordinates.TotalSubordinates
ORDER BY subworkers.Name ASC;