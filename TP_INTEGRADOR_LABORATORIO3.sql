USE TP_INTEGRADOR_PARTE1
GO
SELECT*FROM MEDICOS
--A) Listar todos los m�dicos de sexo femenino.
SELECT*FROM MEDICOS WHERE SEXO='F'
--B) Listar todos los m�dicos cuyo apellido finaliza con 'EZ'
SELECT*FROM MEDICOS WHERE APELLIDO LIKE '%EZ'
--C) Listar todos los m�dicos que hayan ingresado a la cl�nica entre el 1/1/1995 y el 31/12/1999. 2011-05-11
SELECT*FROM MEDICOS WHERE FECHAINGRESO BETWEEN '1995-01-01' AND '1999-12-31' 
--D) Listar todos los m�dicos que tengan un costo de consulta mayor a $ 650.
SELECT*FROM MEDICOS WHERE COSTO_CONSULTA>650
--E) Listar todos los m�dicos que tengan una antig�edad mayor a 10 a�os.
SELECT * FROM MEDICOS WHERE YEAR(GETDATE()) - YEAR(FECHAINGRESO) > 10
--F) Listar todos los pacientes que posean la Obra social 'Dasuten'.
--SELECT*FROM PACIENTES
--SELECT*FROM OBRAS_SOCIALES
SELECT*FROM PACIENTES AS P INNER JOIN OBRAS_SOCIALES AS O ON P.IDOBRASOCIAL=O.IDOBRASOCIAL AND O.NOMBRE='DASUTEN'
--G) Listar todos los pacientes que hayan nacido en los meses de Enero, Febrero o Marzo.
SELECT *FROM PACIENTES WHERE MONTH(FECHANAC)IN(1,2,3)
--H) Listar todos los pacientes que hayan tenido alg�n turno m�dico en los �ltimos 45 d�as.
SELECT*FROM PACIENTES AS P INNER JOIN TURNOS AS T ON T.IDPACIENTE=P.IDPACIENTE WHERE T.FECHAHORA BETWEEN GETDATE()-45 AND GETDATE()
--I) Listar todos los pacientes que hayan tenido alg�n turno con alg�n m�dico con especialidad
--'Gastroenterolog�a'.
SELECT DISTINCT P.APELLIDO, P.NOMBRE FROM PACIENTES AS P INNER JOIN TURNOS AS T ON T.IDPACIENTE=P.IDPACIENTE
INNER JOIN MEDICOS AS M ON M.IDMEDICO=T.IDMEDICO
INNER JOIN ESPECIALIDADES AS E ON E.IDESPECIALIDAD=M.IDESPECIALIDAD AND E.NOMBRE='Gastroenterolog�a'

SELECT DISTINCT P.APELLIDO, P.NOMBRE FROM PACIENTES AS P
INNER JOIN TURNOS AS T ON T.IDPACIENTE = P.IDPACIENTE
INNER JOIN MEDICOS AS M ON M.IDMEDICO = T.IDMEDICO
INNER JOIN ESPECIALIDADES AS E ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
WHERE E.NOMBRE LIKE 'GASTROENTEROLOG�A'
--J) Listar Apellido, nombre, sexo y especialidad de todos los m�dicos que tengan especialidad
--en alg�n tipo de 'An�lisis'
SELECT M.APELLIDO,M.NOMBRE,M.SEXO,E.NOMBRE AS 'ESPECIALIDAD' FROM MEDICOS AS M INNER JOIN ESPECIALIDADES AS E
ON M.IDESPECIALIDAD=E.IDESPECIALIDAD AND E.NOMBRE LIKE'%AN�LISIS%'

--K) Listar Apellido, nombre, sexo y especialidad de todos los m�dicos que no posean la
--especialidad 'Gastroenterolog�a', 'Oftalmolog�a', 'Pediatr�a', 'Ginecolog�a' ni 'Oncolog�a'.
SELECT M.APELLIDO,M.NOMBRE,M.SEXO,E.NOMBRE AS 'ESPECIALIDAD' FROM MEDICOS AS M INNER JOIN ESPECIALIDADES AS E
ON M.IDESPECIALIDAD=E.IDESPECIALIDAD AND E.NOMBRE NOT IN('GASTROENTEROLOG�A', 'OFTALMOLOG�A', 'PEDIATR�A', 'Ginecolog�a', 'ONCOLOG�A')

--L) Listar por cada turno, la fecha y hora, nombre y apellido del m�dico, nombre y apellido del
--paciente, especialidad del m�dico, duraci�n del turno, costo de la consulta sin descuento, obra
--social del paciente y costo de la consulta con descuento de la obra social. Ordenar el listado de
--forma cronol�gica. Del �ltimo turno al primero.
----------FORMA1
SELECT T.IDTURNO,T.FECHAHORA,M.NOMBRE AS 'NOMBRE_MEDICO',M.APELLIDO AS 'APELLIDO_MEDICO',P.NOMBRE AS 'NOMBRE PACIENTE',P.APELLIDO AS 'APELLIDO_PACIENTE',
E.NOMBRE AS'E_MEDICO',T.DURACION,M.COSTO_CONSULTA'COSTO CONSULTA',M.COSTO_CONSULTA*(1-O.COBERTURA) AS 'CONSULTA CON DESCUENTO' FROM TURNOS AS T
INNER JOIN MEDICOS AS M ON T.IDMEDICO=M.IDMEDICO
INNER JOIN PACIENTES AS P ON T.IDPACIENTE=P.IDPACIENTE
INNER JOIN ESPECIALIDADES AS E ON M.IDESPECIALIDAD=E.IDESPECIALIDAD
INNER JOIN OBRAS_SOCIALES AS O ON P.IDOBRASOCIAL=O.IDOBRASOCIAL
ORDER BY T.FECHAHORA DESC
---FORMA2
SELECT T.FECHAHORA, M.APELLIDO + ', ' + M.NOMBRE AS 'MEDICO', P.APELLIDO + ', ' + P.NOMBRE AS 'PACIENTE',
E.NOMBRE, T.DURACION, M.COSTO_CONSULTA, OS.NOMBRE, M.COSTO_CONSULTA * (1-OS.COBERTURA) AS 'COSTO DTO'
FROM TURNOS AS T 
INNER JOIN PACIENTES AS P ON P.IDPACIENTE = T.IDPACIENTE
INNER JOIN MEDICOS AS M ON M.IDMEDICO = T.IDMEDICO
INNER JOIN ESPECIALIDADES AS E ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
INNER JOIN OBRAS_SOCIALES AS OS ON OS.IDOBRASOCIAL = P.IDOBRASOCIAL
ORDER BY T.FECHAHORA DESC

--M) Listar todos los pacientes que no se hayan atendido con ning�n m�dico.

--N) Listar por cada a�o, mes y paciente la cantidad de turnos solicitados. Del paciente mostrar
--P�gina 1 de 2
--Apellido y nombre.
--�) Listar el/los paciente que haya tenido el turno con mayor duraci�n.
--O) Listar el promedio de duraci�n de un turno que pertenezcan a m�dicos con especialidad
--'Pediatr�a'.
--P) Listar por cada m�dico, el total facturado (sin descuentos) agrupado por a�o. Listar apellido
--y nombre del m�dico.
--Q) Listar por cada especialidad la cantidad de turnos que se solicitaron en total. Listar nombre
--de la especialidad.
--S) Listar todos los m�dicos que nunca atendieron a pacientes con Obra Social 'Dasuten'.
--T) Listar todos los pacientes que no se atendieron durante todo el a�o 2015.
--U) Listar para cada paciente la cantidad de turnos solicitados con m�dicos que realizan
--"An�lisis" y la cantidad de turnos solicitados con m�dicos de otras especialidades.
--V) Listar todos los m�dicos que no atendieron nunca por la ma�ana. Horario de 08:00 a 12:00.
--X) Listar las obras sociales que tengan m�s de 10 afiliados en la cl�nica.
--Y) Listar todos los pacientes que se hayan atendido con m�dicos de otras especialidades pero
---no se hayan atendido con m�dicos que realizan "An�lisis".
--Z) Listar todos los pacientes cuyo promedio de duraci�n por turno sea mayor a 20 minutos.
