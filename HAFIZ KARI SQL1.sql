
use hr;
drop table if exists daily_production cascade;
drop table if exists maintenance cascade;
drop table if exists assets cascade;
drop table if exists employees cascade;
drop table if exists rigs cascade;
drop table if exists regions cascade;

create table Regions (
region_id integer primary key,
region_name varchar(80) not null,
country varchar(80) not null,
operating_area varchar(80) not null
);

create table rig(
rig_id integer primary key,
rig_name varchar(100) not null,
region_id integer not null references regions(region_id),
status varchar(30) not null,
offshore boolean not null,
rig_type varchar(50) not null 
);

create table employees (
employee_id integer primary key,
full_name varchar(120) not null,
department varchar(60) not null,
job_title varchar(100) not null,
email varchar(150) not null unique,
phone varchar(40),
region_id integer references regions(region_id),
hire_date date not null
);

create table assets (
asset_id integer primary key,
rig_id integer not null references rigs(rig_id),
asset_name varchar(100) not null,
asset_category varchar(60) not null,
asset_status varchar(40) not null,
purchase_year integer,
region_id integer not null references regions(region_id)
);

create table maintenance (
maintenance_id integer primary key,
rig_id integer not null references rigs(rig_id),
maintenance_date date not null,
activity varchar(150) not null,
downtime_hours numeric(8,2) not null,
maintenance_status varchar(40) not null
);

create table daily_Production (
production_id integer primary key,
rig_id integer not null references rigs(rig_id),
Production_date date not null,
Production_bbl numeric(12,2),
unit varchar(20) not null default 'barrels',
quality_status varchar(30) not null,
unique(rig_id, production_date)
);

insert into regions (region_id, region_name, country, operating_area) values
(1, 'Niger Delta', 'Nigeria', 'west Africa'),
(2, 'Gulf of Guinea', 'Offshore Nigeria', 'west Africa'),
(3, 'North Africa', 'Algeria', 'North Africa'),
(4, 'Middlr East', 'UAE','Middle East'),
(5, 'west Africa', 'Ghana', 'West Africa');

insert into rig (rig_id, rig_name, region_id, status, offshore, rig_type) values
(101, 'Delta Explorer', 1, 'Active', true, 'jack-up'),
(102, 'Bonny Star', 1, 'Active', true, 'Jack-up'),
(103, 'Forcados pioneer', 1, 'maintenance', true, 'semi-submersible'),
(104, 'Lagos Deep', 2, 'Active', true, 'Drillship'),
(105, 'Atlantic Falcon', 2, 'Active', true, 'Drillship'),
(106, 'Calabar Runner', 2, 'Inactive', true, 'Jack-up'),
(107, 'oran Voyager', 3, 'Active', false, 'Jack-up'),
(108, 'Sahara Driller', 3, 'Active', false, 'semi-submersible'),
(109, 'Abu Dhabi creat', 4, 'active', false, 'jack-up'),
(110, 'Tema Horizon', 5, 'Active', true, 'Jack-up'),
(111, 'Volta Mariner', 5, 'Inactive', true, 'Semi-submersible'),
(112, 'Akosombo Deep', 5, 'Active', true, 'Drillship');

insert into employees (employee_id, full_name, Department, job_title, email, phone, region_id, hire_date) values
(1001, 'Amina Yusuf', 'HR', 'HR Manager', 'amina.yusuf@energygycorp.example', '+23480111111001', 1, '2021-02-15'),
(1002, 'Daniel Okoro', 'Operations', 'Production Analyst', 'daniel.okoro@energycorp.example', '+23480111111002', 1, '2022-06-20'),
(1003, 'Fatime Bello', 'Finance', 'finance Analyst', 'fatima.bello@energycorp.example', null, 1, '2023-01-10'),
(1004, 'Ibrahim Musa', 'IT', 'Database Administrator', 'ibrahim.musa@energycorp.example', '+23480111111004', 2, '2020-09-01'),
(1005, 'Grace Eze', 'Operations', 'Rig Engineer', 'grace.eze@energycorp.example', '+23480111111005', 2, '2021-11-11'),
(1006, 'John mensah', 'Maintenance', 'Maintenance Planner', 'john.mensah@energycorp.example', '+23480111111006', 5, '2022-03-18'),
(1007, 'Maryam Aliyu', 'HR', 'HR Officer', 'maryam.aliyu@energycorp.example', null, 4, '2024-04-22'),
(1008, 'Peter Adeyemi', 'Operations', 'Production Supervisor', 'peter.adeyemi@energycorp.example', '+2348011111008', 1, '2019-07-30'),
(1009, 'Zainab Lawal', 'HSE', 'HSE Specialist', 'zainab.lawal@energycorp.example', '+2348011111009', 1, '2020-01-14'),
(1010, 'Samuel Boateng', 'Logistics', 'Logistics Coordinator', 'samuel.boateng@energycorp.example', '+2348011111010', 5, '2023-05-09'),
(1011, 'Ngori Obi', 'Finance', 'Cost Analyst', 'ngori.obi@energycorp.example', NULL, 2, '2024-02-01'),
(1012, 'Khalid Hassan', 'IT', 'Systems Engineer', 'khalid.hassan@energycorp.example', '+2348011111012', 4, '2021-09-12'),
(1013, 'Esther Danjuma', 'Operations', 'Production Analyst', 'esther.danjuma@energycorp.example', '+2348011111013', 3, '2022-09-19'),
(1014, 'Yusuf Ibrahim', 'Maintenance', 'Maintenance Engineer', 'yusuf.ibrahim@energycorp.example', '+2348011111014', 3, '2020-08-05'),
(1015, 'Linda Mensah', 'HSE', 'HSE Analyst', 'linda.mensah@energycorp.example', '+233241111015', 5, '2023-03-16');

insert into Assets (Asset_id, rig_id, Asset_name, Asset_category, Asset_status, purchase_year, region_id) values
(9001, 101, 'Top Drive', 'Drilling', 'Operational', 2018, 1),
(9002, 101, 'Mud Pump', 'Drilling', 'Operational', 2019, 1),
(9003, 102, 'Drawworks', 'Drilling', 'Opertional', 2017, 1),
(9004, 104, 'BOP System', 'Safety', 'Operational', 2020, 2),
(9005, 105, 'Subsea BOP', 'Safety', 'Operational', 2021, 2),
(9006, 107, 'Mud Pump', 'Drilling', 'Operational', 2016, 3),
(9007, 109, 'Hydraulic Unit', 'Power', 'Operational', 2019, 4),
(9008, 110, 'Generator', 'Power', 'Operational', 2018, 5),
(9009, 112, 'Mud Pump', 'Drilling', 'Operational', 2016, 5),
(9010, 103, 'Pump system', 'Production', 'Under Maintenance', 2015, 1),
(9011, 108, 'BOP System', 'Safety', 'Operational', 2017, 3),
(9012, 105, 'Generator', 'Power', 'Operational', 2020, 2);

INSERT INTO maintenance (maintenance_id, rig_id, maintenance_date, activity, downtime_hours, maintenance_status) VALUES
(5001, 103, '2026-01-08', 'Pump replacement', 38, 'Completed'),
(5002, 101, '2026-01-19', 'Routine inspection', 8, 'Completed'),
(5003, 104, '2026-02-04', 'BOP inspection', 22, 'Completed'),
(5004, 105, '2026-02-16', 'Sensor fault', 14, 'Completed'),
(5005, 107, '2026-03-03', 'Well-control test', 12, 'Completed'),
(5006, 109, '2026-03-11', 'Hydraulic maintenance', 18, 'Completed'),
(5007, 110, '2026-03-22', 'Generator service', 10, 'Completed'),
(5008, 112, '2026-04-05', 'Mud pump service', 26, 'Completed'),
(5009, 102, '2026-04-17', 'Crane inspection', 6, 'Completed'),
(5010, 104, '2026-05-02', 'Telementary upgrade', 16, 'Completed'),
(5011, 101, '2026-05-18', 'Preventive maintenance', 7, 'Completed'),
(5012, 105, '2026-06-09', 'Valve replacement', 20, 'Completed'),
(5013, 108, '2026-06-21', 'BOP maintenance', 30, 'Completed'),
(5014, 109, '2026-07-13', 'Electrical fault', 11, 'Completed'),
(5015, 109, '2026-08-07', 'Safety system test', 9, 'Completed');

