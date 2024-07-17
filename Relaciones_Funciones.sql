DROP DATABASE IF EXISTS empresa;
CREATE DATABASE empresa;
USE empresa;

CREATE TABLE departamentos (
    departamento_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    departamento_id INT
    -- FOREIGN KEY (departamento_id) REFERENCES departamentos(departamento_id)
);

CREATE TABLE detalles_empleado (
    empleado_id INT PRIMARY KEY,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id)
);

alter table empleados add detalles_empleado INT;
alter table empleados
add constraint fk_detalles_empleado FOREIGN key (detalles_empleado)
references detalles_empleado(empleado_id);


CREATE TABLE proyectos (
    proyecto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE empleado_proyecto (
    empleado_id INT,
    proyecto_id INT,
    PRIMARY KEY (empleado_id, proyecto_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(proyecto_id)
);

INSERT INTO departamentos (nombre) VALUES
('Recursos Humanos'),
('Tecnología'),
('Ventas'),
('Finanzas');

INSERT INTO empleados (nombre, salario, departamento_id, detalles_empleado) VALUES
('Juan Pérez', 50000.00, 1, null),
('María López', 60000.00, 2, null),
('Carlos Sánchez', 45000.00, 3, null),
('Ana Gómez', 70000.00, 4, null);


INSERT INTO detalles_empleado (empleado_id, direccion, telefono) VALUES
(1, 'Calle 123, Ciudad A', '1234567890'),
(2, 'Avenida 456, Ciudad B', '0987654321'),
(3, 'Calle 789, Ciudad C', '1122334455'),
(4, 'Avenida 101, Ciudad D', '6677889900');

-- update para cambiar los null a los valores empleado_id de detalles_empleado

update empleados e
join detalles_empleado de on e.empleado_id = de.empleado_id 
set e.detalles_empleado = de.empleado_id;

INSERT INTO proyectos (nombre) VALUES
('Proyecto Alfa'),
('Proyecto Beta'),
('Proyecto Gamma'),
('Proyecto Delta');


-- 3 Crea una función llamada calcular_bonificacion que tome como parámetro el empleado_id y 
-- devuelva una bonificación calculada como el 10% del salario del empleado. Utiliza la cláusula DETERMINISTIC en la definición de la función.

-- 4 Asegúrate de utilizar un delimitador (DELIMITER) diferente al punto y coma (;) al definir
--  la función en el paso anterior. Luego, restablece el delimitador a su valor original.
-- 6 Declarar Variables y Usarlas ESTA HECHA EN ESTE EJERCICIO
DELIMITER $$
	create function calcular_bonificacion (empleado_id int) 
	returns decimal(10,2)
	deterministic
	begin
		declare salario_base decimal (10,2);
		declare bonificacion decimal (10,2);
		declare salario_total decimal (10,2);
		select salario into salario_base from empleados e where e.empleado_id = empleado_id;
		set bonificacion = salario_base * 0.10; 
		set salario_total = salario_base + bonificacion;
		return salario_total;
	end$$

DELIMITER ;

select 
	calcular_bonificacion(empleado_id) as salario_total
from
	empleados;

-- 5 Crea una restricción (CONSTRAINT) de integridad referencial con nombre 
-- fk_departamento_empleado en la relación ManyToOne entre empleados y departamentos. 
-- Luego, utiliza este nombre para eliminar la restricción.

alter table empleados drop column departamento_id;
alter table empleados add departamento_id INT;
alter table empleados
add constraint fk_departamento_empleado FOREIGN key (departamento_id)
references departamentos(departamento_id);

alter table empleados Drop foreign key fk_departamento_empleado;


