set linesize 480

--======================= Create and Insert Data into Tables ================================================================

--Drop all tables, starting with the weak entities, then the strong entities
    --Drop all tables of weak entities
drop table Service_Invoice;
drop table FSR;
drop table AS_Job;
drop table BME_Job;
drop table BME;
drop table Technician;
drop table Technical_Service_Manager;
drop table Part;
drop table Part_Assignment;
    --Drop all tables of strong entities
drop table Chief_Biomedical_Engineer;
drop table Company_Director_and_Founder;
drop table Medical_Equipment_Asset_No;
drop table Medical_Equipment_Serial_No;
drop table Medical_Equipment_Model;


------------------ CREATE TABLES ------------------------------------------

--Create all tables of Strong entities
create table Company_Director_and_Founder
(Employee_ID INT,
 Employee_Name CHAR(30) NULL,
 Employee_Role CHAR(35) NULL,
 Employee_Dept CHAR(35) NULL,
 Phone_No INT NULL,
 Email CHAR(45) NULL,
 CONSTRAINT CDAF_Employee_ID_PK PRIMARY KEY (Employee_ID));
 
 create table Chief_Biomedical_Engineer
(Employee_ID INT,
 Employee_Name CHAR(30) NULL,
 Employee_Role CHAR(28) NULL,
 Manager_Emp_ID INT NULL,
 Employee_Dept CHAR(35) NULL,
 Phone_No INT NULL,
 Email CHAR(45) NULL,
 CONSTRAINT CBE_Employee_ID_PK PRIMARY KEY (Employee_ID));
 
 create table Medical_Equipment_Asset_No
(Asset_No CHAR(8) NOT NULL,
 Equipment_Location CHAR(20) NULL,
 Comission_Date DATE NULL,
 Equipment_Status VARCHAR(10),
 CONSTRAINT Medical_Equipment_Asset_No_PK PRIMARY KEY (Asset_No));
 
  create table Medical_Equipment_Serial_No
(Serial_No CHAR(20) NOT NULL,
 Equipment_Category CHAR(40) NULL,
 CONSTRAINT Medical_Equipment_Serial_No_PK PRIMARY KEY (Serial_No));
 
 
create table Medical_Equipment_Model
(Model CHAR(25) NOT NULL,
 Brand CHAR(15) NULL,
 CONSTRAINT Medical_Equipment_Model_PK PRIMARY KEY (Model));
 
 --Create all tables for Weak Entities
 create table Part
(Item_No INT,
 Description VARCHAR(40) NULL,
 Sell_Price NUMBER NULL,
 Purchase_Price NUMBER NULL,
 Manufacturer CHAR(20) NULL,
 CONSTRAINT Item_No_PK PRIMARY KEY (Item_No));

 create table Technical_Service_Manager
(Employee_ID INT,
 Employee_Name CHAR(30) NULL,
 Employee_Role CHAR(28) NULL,
 Manager_Emp_ID INT CONSTRAINT TSM_Manager_Emp_ID_FK REFERENCES Company_Director_and_Founder(Employee_ID),
 Employee_Dept CHAR(35) NULL,
 Phone_No INT NULL,
 Email CHAR(45) NULL,
 CONSTRAINT TSM_Employee_ID_PK PRIMARY KEY (Employee_ID));
 
 create table Technician
(Employee_ID INT,
 Employee_Name CHAR(30) NULL,
 Employee_Role CHAR(28) NULL,
 Manager_Emp_ID INT CONSTRAINT T_Manager_Emp_ID_FK REFERENCES Technical_Service_Manager(Employee_ID),
 Employee_Dept CHAR(35) NULL,
 Phone_No INT NULL,
 Email CHAR(45) NULL,
 CONSTRAINT T_Employee_ID_PK PRIMARY KEY(Employee_ID));

 create table AS_Job
(AS_Job_No INT,
 AS_Job_Creation_Date DATE NULL,
 Healthcare_Facility CHAR(30) NULL,
 Technician_Emp_ID INT CONSTRAINT Technician_Emp_ID_FK REFERENCES Technician(Employee_ID),
 Equipment_Location CHAR(20),
 Equipment_Asset_No CHAR(8) CONSTRAINT AS_Job_Equipment_Asset_No_FK REFERENCES Medical_Equipment_Asset_No(Asset_No),
 Equipment_Serial_No CHAR(20) CONSTRAINT AS_Job_Equipment_Serial_No_FK REFERENCES Medical_Equipment_Serial_No(Serial_No),
 Equipment_Model CHAR(25) NULL,
 Equipment_Brand CHAR(15) NULL,
 AS_Job_Category CHAR(15) NULL,
 AS_Job_Request VARCHAR(15) NULL,
 CONSTRAINT AS_Job_No_PK PRIMARY KEY(AS_Job_No));
 
create table FSR
(FSR_No INT,
 AS_Job_No INT CONSTRAINT AS_Job_No_FK REFERENCES AS_Job(AS_Job_No),
 FSR_Creation_Date DATE NULL,
 Healthcare_Facility CHAR(30) NULL,
 Technician_Emp_ID INT CONSTRAINT FSR_Technician_Emp_ID_FK REFERENCES Technician(Employee_ID),
 Equipment_Location CHAR(20) NULL,
 Equipment_Asset_No CHAR(8) CONSTRAINT FSR_Equipment_Asset_No_FK REFERENCES Medical_Equipment_Asset_No(Asset_No),
 Equipment_Serial_No CHAR(20) CONSTRAINT FSR_Equipment_Serial_No_FK REFERENCES Medical_Equipment_Serial_No(Serial_No),
 Equipment_Model CHAR(25) NULL,
 Equipment_Brand CHAR(15) NULL,
 AS_Job_Category CHAR(15) NULL,
 AS_Job_Request VARCHAR(15) NULL,
 Service_Hours_Taken INT NULL,
 Job_Performed VARCHAR(25) NULL,
 CONSTRAINT FSR_No_PK PRIMARY KEY (FSR_No));
 
 create table Service_Invoice
(Invoice_No INT,
 FSR_No INT CONSTRAINT Service_Invoice_FSR_No_FK REFERENCES FSR(FSR_No),
 Technician_Emp_ID INT CONSTRAINT Service_Invoice_Technician_Emp_ID_FK REFERENCES Technician(Employee_ID),
 Invoice_Creation_Date DATE NULL,
 BME_Dept CHAR(40) NULL,
 Service_Charge NUMBER NULL,
 Equipment_Asset_No CHAR(8) CONSTRAINT Service_Invoice_Equipment_Asset_No_FK REFERENCES Medical_Equipment_Asset_No(Asset_No),
 Equipment_Serial_No CHAR(20) CONSTRAINT Service_Invoice_Equipment_Serial_No_FK REFERENCES Medical_Equipment_Serial_No(Serial_No),
 Equipment_Model CHAR(25),
 Equipment_Brand CHAR(15),
 AS_Job_Category CHAR(15),
 Service_Hours_Taken INT NULL,
 CONSTRAINT Invoice_No_PK PRIMARY KEY (Invoice_No));
 
 create table Part_Assignment
(Invoice_No INT CONSTRAINT Part_Assignment_Invoice_No_FK REFERENCES Service_Invoice(Invoice_No),
 Item_No INT CONSTRAINT Part_Assignment_Item_No_FK REFERENCES Part(Item_No),
 Part_Quantity INT,
 CONSTRAINT Part_Assignment_PK PRIMARY KEY (Invoice_No, Item_No));
 
 create table BME
(Employee_ID INT,
 Employee_Name CHAR(30) NULL,
 Employee_Role CHAR(28) NULL,
 Manager_Emp_ID INT CONSTRAINT BME_Manager_Emp_ID REFERENCES Chief_Biomedical_Engineer(Employee_ID),
 Employee_Dept CHAR(35) NULL,
 Phone_No INT NULL,
 Email CHAR(45) NULL,
 CONSTRAINT BME_Employee_ID_PK PRIMARY KEY (Employee_ID));
 
 create table BME_Job
(BME_Job_No INT,
 BME_Job_Creation_Date DATE NULL,
 Equipment_Asset_No CHAR(8) CONSTRAINT BME_Job_Equipment_Asset_No_FK REFERENCES Medical_Equipment_Asset_No(Asset_No),
 BME_Emp_ID INT CONSTRAINT BME_Job_BME_Emp_ID_FK REFERENCES BME(Employee_ID),
 Equipment_Location CHAR(20),
 BME_Job_Description CHAR(25) NULL,
 BME_Job_Category CHAR(15) NULL,
 BME_Job_Status VARCHAR(15) NULL,
 CONSTRAINT BME_Job_PK PRIMARY KEY(BME_Job_No));
 

-------- POPULATE TABLES WITH DATA --------------------

--Company Founder and Director
 insert into Company_Director_and_Founder values (100000, 'John Mcleoud', 'Director and Founder', 'Activtec Solutions', 1300304645, 'j.mcleod@activtec.com.au');
 
 --Chief Biomedical Engineer
 insert into Chief_Biomedical_Engineer values (102830, 'John Dang', 'Chief Biomedical Engineer', 98215, 'Biomedical Engineering', 83451020, 'john.dang@wh.org.au');
 
  --Medical Equipment Asset Number
 insert into Medical_Equipment_Asset_No values ('WH100683', 'Ward 3A', '30-JUN-2011', 'Active');
 insert into Medical_Equipment_Asset_No values ('WH102276', 'DAS West', '12-AUG-2008', 'Inactive');
 insert into Medical_Equipment_Asset_No values ('MH104232', 'Ward 3Esat', '10-APR-2018', 'Active');
 insert into Medical_Equipment_Asset_No values ('NH106348', 'Pysch Ward', '18-JAN-2011', 'Lost');
 insert into Medical_Equipment_Asset_No values ('HA108830', 'Orygen', '07-JUL-2016', 'Active');
 insert into Medical_Equipment_Asset_No values ('HH101643', 'Rehabilitation', '07-AUG-2017', 'Active');
 insert into Medical_Equipment_Asset_No values ('WH102841', 'Operating Theatres', '09-DEC-2004', 'Inactive');
 insert into Medical_Equipment_Asset_No values ('JK103123', 'Recovery', '27-MAR-2014', 'Lost');
 insert into Medical_Equipment_Asset_No values ('EH123557', 'Emergency Department', '02-NOV-2006', 'Active');
 insert into Medical_Equipment_Asset_No values ('WH112113', 'Radiology', '29-JUN-2005', 'Inactive');
 
 --Medical Equipment Serial Number
 insert into Medical_Equipment_Serial_No values ('A7479B015', 'Patient Lifter');
 insert into Medical_Equipment_Serial_No values ('NKS563', 'Syringe Pump');
 insert into Medical_Equipment_Serial_No values ('77434', 'BP Machine');
 insert into Medical_Equipment_Serial_No values ('DNO455C24', 'Infusion Pump');
 insert into Medical_Equipment_Serial_No values ('1346720264', 'Weight Scale');
 insert into Medical_Equipment_Serial_No values ('34B34KLM', 'Patient Monitor');
 insert into Medical_Equipment_Serial_No values ('D355NM352', 'CPAP');
 insert into Medical_Equipment_Serial_No values ('6340052', 'Infrared Thermometer');
 insert into Medical_Equipment_Serial_No values ('DE213K30', 'CO2 Module');
 insert into Medical_Equipment_Serial_No values ('551J1QP', 'Ventilator');
 
  --Medical Equipment Model
 insert into Medical_Equipment_Model values ('Lite Chair', 'Pegasus');
 insert into Medical_Equipment_Model values ('Asena', 'Carefusion');
 insert into Medical_Equipment_Model values ('Vit-Signs', 'Welch Allyn');
 insert into Medical_Equipment_Model values ('Alaris', 'Carefusion');
 insert into Medical_Equipment_Model values ('TC200', 'CWS');
 insert into Medical_Equipment_Model values ('CPAP200', 'Arjo Huntley');
 insert into Medical_Equipment_Model values ('B450', 'GE Healthcare');
 insert into Medical_Equipment_Model values ('TAT-5000', 'Intermed');
 insert into Medical_Equipment_Model values ('CA-251', 'Philips');
 insert into Medical_Equipment_Model values ('Hamilton-T1', 'Macquet');
 
 --Part
 insert into Part values (1274855, 'Arjo Bianca Lifter Handset', 250, 64, 'Arjo Huntley');
 insert into Part values (5234559, '12V 2.5 ah Powersonic Battery', 170, 85, 'Panasonic');
 insert into Part values (6342552, 'Arjo Basic ST Stretcher', 572, 110, 'Arjo Huntley');
 insert into Part values (1563245, '200 Series Air Mattress', 763, 320, 'Philips');
 insert into Part values (2355238, 'Accumax CU1 Green Light', 86, 12, 'Accumax');
 insert into Part values (9928858, 'Airlo 5 Compressor', 611, 210, 'Airlo');
 insert into Part values (7993045, 'Cirrus Front Panel PCB', 772, 122, 'Cirrus');
 insert into Part values (5672001, '12V 33ah Gel Battery Ozcharge', 234, 91, 'AMG');
 insert into Part values (8981235, 'Call Station Vertical Questek', 432, 118, 'Masters Instruments');
 insert into Part values (8655408, 'Nurse Pendants Mono', 146, 43, 'GE Healthcare');

 --Technical Service Manager
 insert into Technical_Service_Manager values (104224, 'Jason Baker', 'Technical Service Manager', 100000, 'Activtec Solutions', 1300349646, 'j.baker@activtec.com.au');
 
 --Technician
 insert into Technician values (105993, 'William Douglas', 'Technician', 104224, 'Activtec Solutions', 1300349671, 'w.douglas@activtec.com.au');
 insert into Technician values (106772, 'Carol Jacqueline', 'Technician', 104224, 'Activtec Solutions', 1300349672, 'c.Jacqueline@activtec.com.au');
 insert into Technician values (106801, 'James Conner', 'Technician', 104224, 'Activtec Solutions', 1300349686, 'j.douglas@activtec.com.au');
 insert into Technician values (107331, 'Hai Nguyen', 'Technician', 104224, 'Activtec Solutions', 1300349752, 'j.conner@activtec.com.au');
 insert into Technician values (107518, 'Mary Jones', 'Technician', 104224, 'Activtec Solutions', 1300349812, 'm.jones@activtec.com.au');
 insert into Technician values (107610, 'Antonio Garcia', 'Technician', 104224, 'Activtec Solutions', 1300349855, 'a.garcia@activtec.com.au');
 insert into Technician values (108041, 'Dorothy Larisa ', 'Technician', 104224, 'Activtec Solutions', 1300349879, 'd.larisa@activtec.com.au');
 insert into Technician values (108991, 'Anthony Michaels', 'Technician', 104224, 'Activtec Solutions', 1300349901, 'a.michaels@activtec.com.au');
 insert into Technician values (109529, 'Jess Brown', 'Technician', 104224, 'Activtec Solutions', 1300349968, 'j.brown@activtec.com.au');
 insert into Technician values (109835, 'Chau Le', 'Technician', 104224, 'Activtec Solutions', 1300359972, 'c.le@activtec.com.au');

 --AS Job
 insert into AS_Job values (1002787, '14-NOV-2019', 'Sunshine Hospital', 106772, 'Ward 3A', 'WH100683', 'A7479B015', 'Lite Chair', 'Pegasus', 'Patient Lifter', 'Maintenance');
 insert into AS_Job values (1002790, '18-DEC-2019', 'Footscray Hospital', 106801, 'DAS West', 'WH102276', 'NKS563', 'Asena', 'Carefusion', 'Syringe Pump', 'Repair');
 insert into AS_Job values (1003012, '07-JAN-2020', 'Hazeldean Aged Care', 107518, 'Ward 3Esat', 'MH104232', '77434', 'Vit-Signs', 'Welch Allyn', 'Patient Lifter', 'Repair');
 insert into AS_Job values (1003052, '12-MAR-2020', 'Sunbury Hospital', 108991, 'Pysch Ward', 'NH106348', 'DNO455C24', 'Alaris', 'Carefusion', 'Infusion Pump', 'Repair');
 insert into AS_Job values (1003605, '29-MAR-2020', 'Melton Hospital', 106772, 'Orygen', 'HA108830', '1346720264', 'TC200', 'CWS', 'Weight Scale', 'Maintenance');
 insert into AS_Job values (1004034, '07-MAY-2020', 'Peninsula Private Hospital', 109835, 'Rehabilitation', 'HH101643', 'A7479B015', 'CPAP200', 'Arjo Huntley', 'Patient Lifter', 'Maintenance');
 insert into AS_Job values (1006133, '18-JUN-2020', 'Williamstown Hospital', 107331, 'Operating Theatres', 'WH102841', 'D355NM352', 'Patient Monitor', 'B450', 'GE Healthcare', 'Maintenance');
 insert into AS_Job values (1007102, '09-JUL-2020', 'Epping Hospital', 108041, 'Recovery', 'JK103123', '6340052', 'Infrared Thermometer', 'TAT-5000', 'Intermed', 'Maintenance');
 insert into AS_Job values (1013539, '22-AUG-2020', 'Melton Hospital', 109529, 'Emergency Department', 'EH123557', 'DE213K30', 'CO2 Module', 'CA-251', 'Philips', 'Repair');
 insert into AS_Job values (1010627, '26-SEP-2020', 'Werribe Hospital', 109835, 'Radiology', 'WH112113', '551J1QP', 'Ventilator', 'Hamilton-T1', 'Macquet', 'Maintenance');
 
 --FSR
 insert into FSR values (1103788, 1002787, '15-NOV-2019', 'Sunshine Hospital', 106772, 'Ward 3A', 'WH100683', 'A7479B015', 'Lite Chair', 'Pegasus', 'Patient Lifter', 'Maintenance', 2, 'Reconfigured handset');
 insert into FSR values (1104753, 1002790, '20-DEC-2019', 'Footscray Hospital', 106801, 'DAS West', 'WH102276', 'NKS563', 'Asena', 'Carefusion', 'Syringe Pump', 'Repair', 1, 'Replaced battery');
 insert into FSR values (1105215, 1003012, '10-JAN-2020', 'Hazeldean Aged Care', 107518, 'Ward 3Esat', 'MH104232', '77434', 'Vit-Signs', 'Welch Allyn', 'Patient Lifter', 'Repair', 2, 'Repositioned handle');
 insert into FSR values (1105674, 1003052, '15-MAR-2020', 'Sunbury Hospital', 108991, 'Pysch Ward', 'NH106348', 'DNO455C24', 'Alaris', 'Carefusion', 'Infusion Pump', 'Repair', 3, 'Replaced compressor');
 insert into FSR values (1109884, 1003605, '30-MAR-2020', 'Melton Hospital', 106772, 'Orygen', 'HA108830', '1346720264', 'TC200', 'CWS', 'Weight Scale', 'Maintenance', 5, 'Recalibrted Scale');
 insert into FSR values (1123661, 1004034, '09-MAY-2020', 'Peninsula Private Hospital', 109835, 'Rehabilitation', 'HH101643', 'A7479B015', 'CPAP200', 'Arjo Huntley', 'Patient Lifter', 'Maintenance', 2, 'Functional Test');
 insert into FSR values (1175433, 1006133, '20-JUN-2020', 'Williamstown Hospital', 107331, 'Operating Theatres', 'WH102841', 'D355NM352', 'Patient Monitor', 'B450', 'GE Healthcare', 'Maintenance', 3, 'Replace handle');
 insert into FSR values (1187727, 1007102, '11-JUL-2020', 'Epping Hospital', 108041, 'Recovery', 'JK103123', '6340052', 'Infrared Thermometer', 'TAT-5000', 'Intermed', 'Maintenance', 1, 'Calibrated temperature');
 insert into FSR values (1198383, 1013539, '25-AUG-2020', 'Melton Hospital', 109529, 'Emergency Department', 'EH123557', 'DE213K30', 'CO2 Module', 'CA-251', 'Philips', 'Repair', 1, 'Replaced Main PCB');
 insert into FSR values (1236633, 1010627, '30-SEP-2020', 'Werribe Hospital', 109835, 'Radiology', 'WH112113', '551J1QP', 'Ventilator', 'Hamilton-T1', 'Macquet', 'Maintenance', 3, 'Functional Test');
 
 --Service Invoice
 insert into Service_Invoice values (123789, 1103788, 105993, '16-NOV-2019', 'Sunshine Hospital', 820,'WH100683', 'A7479B015', 'Lite Chair', 'Pegasus', 'Maintenance', 2);
 insert into Service_Invoice values (124754, 1104753, 106772, '21-DEC-2019', 'Footscray Hospital', 578, 'WH102276', 'NKS563', 'Asena', 'Carefusion', 'Repair', 1);
 insert into Service_Invoice values (125216, 1105215, 106801, '11-JAN-2020', 'Hazeldean Aged Care', 672, 'MH104232', '77434', 'Vit-Signs', 'Welch Allyn', 'Repair', 2);
 insert into Service_Invoice values (125675, 1105674, 107331, '16-MAR-2020', 'Sunbury Hospital', 887, 'NH106348', 'DNO455C24', 'Alaris', 'Carefusion', 'Repair', 3);
 insert into Service_Invoice values (129885, 1109884, 107518, '01-APR-2020', 'Melton Hospital', 991, 'HA108830', '1346720264', 'TC200', 'CWS', 'Maintenance', 5);
 insert into Service_Invoice values (123662, 1123661, 107610, '10-MAY-2020', 'Peninsula Private Hospital', 502, 'HH101643', 'A7479B015', 'CPAP200', 'Arjo Huntley', 'Maintenance', 2);
 insert into Service_Invoice values (125434, 1175433, 108041, '21-JUN-2020', 'Williamstown Hospital', 1305, 'WH102841', 'D355NM352', 'Patient Monitor', 'B450', 'Maintenance', 3);
 insert into Service_Invoice values (127728, 1187727, 108991, '12-JUL-2020', 'Epping Hospital', 2053, 'JK103123', '6340052', 'Infrared Thermometer', 'TAT-5000', 'Maintenance', 1);
 insert into Service_Invoice values (128384, 1198383, 109529, '26-AUG-2020', 'Melton Hospital', 745, 'EH123557', 'DE213K30', 'CO2 Module', 'CA-251', 'Repair', 1);
 insert into Service_Invoice values (126634, 1236633, 109835, '01-OCT-2020', 'Werribe Hospital', 992, 'WH112113', '551J1QP', 'Ventilator', 'Hamilton-T1', 'Maintenance', 3);
 
 --Part Assignment
 insert into Part_Assignment values (123789, 1274855, 1);
 insert into Part_Assignment values (124754, 5234559, 3);
 insert into Part_Assignment values (125216, 6342552, 3);
 insert into Part_Assignment values (125675, 1563245, 2);
 insert into Part_Assignment values (129885, 2355238, 2);
 insert into Part_Assignment values (123662, 9928858, 1);
 insert into Part_Assignment values (125434, 7993045, 3);
 insert into Part_Assignment values (127728, 5672001, 4);
 insert into Part_Assignment values (128384, 8981235, 1);
 insert into Part_Assignment values (126634, 8655408, 3);
 
 --BME
 insert into BME values (100682, 'Peter Tieu', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451021, 'peter.tieu@wh.org.au');
 insert into BME values (100785, 'Mohammed Khudruj', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451022, 'mohammed.khudruj@wh.org.au');
 insert into BME values (100834, 'Ibraheem Ghairat', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451023, 'ibrhaeem.ghairat@wh.org.au');
 insert into BME values (100713, 'Shema Farahani', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451024, 'shema.farahani@wh.org.au');
 insert into BME values (100942, 'Fariba Abraham', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451025, 'fariba.abraham@wh.org.au');
 insert into BME values (100184, 'Harjap Pouram', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451026, 'harjap.pouram@wh.org.au');
 insert into BME values (100397, 'Sabah Chahal', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451027, 'sabah.chahal@wh.org.au');
 insert into BME values (100432, 'Michael Nguyen', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451028, 'michael.nguyen@wh.org.au');
 insert into BME values (100981, 'Gary Ngo', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451029, 'gary.ngo@wh.org.au');
 insert into BME values (100171, 'Vivian Gibbons', 'Biomedical Engineer', 102830, 'Biomedical Engineering', 83451030, 'vivian.gibbons@wh.org.au');
 
 --BME Job
 insert into BME_Job values (5619022, '14-NOV-2019', 'WH100683', 100682, 'Ward 3A', 'Needs PM', 'Maintenance', 'In Progress');
 insert into BME_Job values (5619023, '18-DEC-2019', 'WH102276', 100785, 'DAS West', 'Needs Repair', 'Repair', 'Completed');
 insert into BME_Job values (5619024, '12-MAR-2020', 'MH104232', 100834, 'Ward 3Esat', 'Needs PM', 'Maintenance', 'Completed');
 insert into BME_Job values (5619025, '29-MAR-2019', 'NH106348', 100713, 'Pysch Ward', 'Broken Pedal', 'Repair', 'Completed');
 insert into BME_Job values (5619026, '07-MAY-2020', 'HA108830', 100942, 'Orygen', 'Needs Functional Test', 'Maintenance', 'In Progress');
 insert into BME_Job values (5619027, '18-JUN-2020', 'HH101643', 100184, 'Rehabilitation', 'Needs PM', 'Maintenance', 'In Progress');
 insert into BME_Job values (5619028, '14-NOV-2019', 'WH102841', 100397, 'Operating Theatres', 'Needs PM', 'Maintenance', 'Completed');
 insert into BME_Job values (5619029, '09-JUL-2020', 'JK103123', 100432, 'Recovery', 'Needs Repair', 'Repair', 'In Progress');
 insert into BME_Job values (5619030, '22-AUG-2020', 'EH123557', 100981, 'Emergency', 'Needs PM', 'Maintenance', 'Outstanding');
 insert into BME_Job values (5619031, '26-SEP-2020', 'WH112113', 100171, 'Radiology', 'Needs PM', 'Maintenance', 'Outstanding');
 
 SELECT table_name FROM user_tables;
 
 
 --------------- Show Tables ---------------------------
 SELECT*FROM Company_Director_and_Founder;
 SELECT*FROM Chief_Biomedical_Engineer;
 SELECT*FROM Medical_Equipment_Asset_No;
 SELECT*FROM Medical_Equipment_Serial_No;
 SELECT*FROM Medical_Equipment_Model;
 SELECT*FROM Part;
 SELECT*FROM Technical_Service_Manager;
 SELECT*FROM Technician;
 SELECT*FROM AS_Job;
 SELECT*FROM FSR;
 SELECT*FROM Service_Invoice;
 SELECT*FROM Part_Assignment;
 SELECT*FROM BME;
 SELECT*FROM BME_Job;
 
 
 --======================= Substitution Variables ===========================================================================
 UPDATE Part SET Sell_Price = Sell_Price * (1+&inflation);
 SELECT*FROM Part;
 
 UPDATE Part SET Sell_Price = Sell_Price * (1+&&inflation);
 SELECT*FROM Part;
 
 UPDATE Part SET Sell_Price = Sell_Price * (1+&&inflation);
 SELECT*FROM Part;
 
 
 --======================= Left Outer Join ==================================================================================
SELECT *
FROM Part_Assignment pa  LEFT OUTER JOIN Part p
ON pa.Item_No = p.Item_No;


--======================= Equi-Join =========================================================================================
SELECT Employee_ID, Employee_Name, BME_Job_Description
FROM BME b, BME_Job bj
WHERE b.Employee_ID = bj.BME_Emp_ID;


--======================= Aggregate Functions with Join and Group By ========================================================
-- Does not work (not used for answer)
SELECT p.Item_No AS Item_Code1,
	   pa.Item_No AS Item_Code2,
	   SUM(p.Sell_Price) as Total_Sell_Price,
	   p.Description AS Descr,
	   COUNT(p.Item_No) AS No_Items,
	   AVG(p.Purchase_Price) AS Avg_Price
FROM Part p JOIN Part_Assignment pa
ON p.Item_No = pa.Item_No;
GROUP BY p.Item_No, p.Description;


--Works (used for answer)
SELECT p.Item_No AS Part_Item_No,
       COUNT(p.Item_No) AS Qty,
	   SUM(p.Purchase_Price) AS Total_Purchase_Price,
	   AVG(p.Purchase_Price) AS Avg_Price
FROM Part p JOIN Part_Assignment pa
ON p.Item_No = pa.Item_No
GROUP BY p.Item_No, p.Description;
 
 
--======================= Nested Select Function ============================================================================
SELECT Item_No, Sell_Price
FROM Part
WHERE Sell_Price >= (SELECT AVG(Sell_Price) FROM Part);
