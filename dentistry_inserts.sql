spool "C:\Users\Tyga\personal_ventures\dental_inserts.sql";

alter table product disable constraint product_size_null;
alter table vendor disable constraint vendor_employee_null;
alter table po_items disable constraint po_items_payable_null;
alter table po disable constraint po_ap_status_null;
--insert into zip
insert into zip values(91110,'CA','Pasadena');
insert into zip values(90007, 'CA','Los Angeles');
insert into zip values(90089,'CA','Los Angeles');
insert into zip values(78682,'TX','Round Rock');
insert into zip values(33781, 'FL','Pinellas Park');
insert into zip values(33496, 'FL','Boca Raton');
insert into zip values(90504, 'CA','Torrance');
insert into zip values(91006, 'CA','Arcadia');
--insert into vendor
insert into vendor values(603046210,'Dell Computer Corp.',1512837544,18002747799,'1 Dell Way',78682,null);
insert into vendor values(153531108,'Office Depot, Inc.',null,18004633768,'6600 N Military Trail',33496,null);
insert into vendor values(111111111,'Data Dentist Devices and Stuff',null,17275555555,'123 Potato Drive',33781,null);

--insert into commodity
insert into commodity values(18, 'Office Supplies and Equipment');
insert into commodity values(14, 'IT Hardware and Maintenance');
insert into commodity values(16, 'Dental Supplies');

--insert into product
insert into product values('1017724224640\1','210-ABDE','210-ABDE',14,'Dell Latitude E7450', 1113.16,null);
insert into product values('544387','OD24030R','544387',18, 'Office Depot(R) Brand Pressboard Classification with Folders with Fasteners, Letter Size, 100 Recycled, Light Blue, Pack of 10', 33.94,null);
insert into product values('132842','001-DENT','001-DENT',16,'Dentures', 99.99,null);
insert into product values('123456','002-CROW','002-CROW',16,'Crowns', 299.99,null);
insert into product values('234567','003-BIBS','003-BIBS',16,'Bibs', 2.99,null);

--insert into size_codes
insert into size_codes values('EA');
insert into size_codes values('BX');

--insert into product_size
insert into product_size values('1017724224640\1','210-ABDE','EA');
insert into product_size values('123456','002-CROW','EA');
insert into product_size values('234567','003-BIBS','EA');
insert into product_size values('544387','OD24030R','BX');
insert into product_size values('132842','001-DENT','EA');

update product set size_code='EA' where supplier_part_aux_id='1017724224640\1' or supplier_part_aux_id='123456'
or supplier_part_aux_id='234567' or supplier_part_aux_id='132842';
update product set size_code='BX' where supplier_part_aux_id='544387';

--insert into vendor_product
insert into vendor_product values(1,603046210,'1017724224640\1','210-ABDE',1113.16);
insert into vendor_product values(2,111111111,'123456','002-CROW',299.99);
insert into vendor_product values(3,153531108,'544387','OD24030R',33.94);
insert into vendor_product values(4,111111111,'234567','003-BIBS',2.99);
insert into vendor_product values(5,111111111,'132842','001-DENT',99.99);

--insert into vendor_emp
insert into vendor_emp values(1,603046210,7426166805,'Jeff','Dahlman');
insert into vendor_emp values(2,153531108,798851330,'Huy','Ngo');
insert into vendor_emp values(3,111111111,472942793,'Douglas','Shook');

update vendor set vendor_employee=1 where supplier_number=603046210;
update vendor set vendor_employee=2 where supplier_number=153531108;
update vendor set vendor_employee=3 where supplier_number=111111111;

--insert into accounts
insert into accounts values(1213050004,'PO Box 77967',90007);
insert into accounts values(1234567890,'PO Box 17380',33781);

--insert into department
insert into department values(2060603000,'Information Technology',1213050004);
insert into department values(2123109112,'Meat Selection',1234567890);

--insert into employee
insert into employee values(1234567890,'Brandon','Crabtree',12137406708,'bcrabtre@usc.edu','925 West 34th St.',90089,2060603000);
insert into employee values(2345678901, 'Huy','Ngo',17273486341, 'huyngo@usc.edu','1151 W. 36th Pl.',90007,2123109112);
insert into employee values(3456789012, 'Jane','Oh',17273486341, 'janeoh@usc.edu','Somewhere in Torrance',90504,2123109112);
insert into employee values(4567890123, 'Wilson','Lin',17273486341, 'wilsonlin@usc.edu','Cardinal Gardens',91006,2123109112);
insert into employee values(4567890124, 'Douglas','Shook',12135555555, 'shook@usc.edu','Cal Building',90007,2060603000);
insert into employee values(4567890125, 'Vicky','Dy',12135555554, 'dy@usc.edu','Dental School',90007,2060603000);

--insert into recipient
insert into recipient values(4567890124,'Cal Building');
insert into recipient values(4567890125,'Dental School');

--insert into purchaser 
insert into purchaser values(3456789012,'Jane Oh''s Account');
insert into purchaser values(4567890123,'Wilson Lin''s Account');
insert into purchaser values(2345678901,'1151 W. 36th Pl. Rm. B');
insert into purchaser values(1234567890,'925 West 34th St.');

--insert into purchase_requisition
insert into purchase_requisition values(66710697,'New Laptop for Tele-Dentistry Clinic per Linda Brookman');
insert into purchase_requisition values(67052957,'Folders for IT Dept.');
insert into purchase_requisition values(67052958,'Dental Supplies');
insert into purchase_requisition values(67052959,'New TV for Bossman');
insert into purchase_requisition values(67052960,'Sour Gummy Worms');

--insert into object_code
insert into object_code values(15102,'General/Project Supplies');
insert into object_code values(15307,'Office Supplies');

--insert into po
insert into po values(10356325,'10/07/2015',15307,1234567890,4567890125,66710697,null);
insert into po values(10353635,'9/30/2015',15102,1234567890,4567890125,67052957,null);
insert into po values(10353636,'12/01/2015',15102,2345678901,4567890124,67052958,null);

--insert ap_status
insert into ap_status values(1,'Soft Closed');
insert into ap_status values(2,'Hard Closed');
insert into ap_status values(3,'Open');
insert into ap_status values(4,'Pending');

--insert into po_ap_status
insert into po_ap_status values(1,10356325,3);
insert into po_ap_status values(2,10353635,1);
insert into po_ap_status values(3,10353636,3);

update po set PO_AP_STATUS_ID=1 where po_number=10356325;
update po set PO_AP_STATUS_ID=2 where po_number=10353635;
update po set PO_AP_STATUS_ID=3 where po_number=10353636;

--insert into po_items
insert into po_items values(2,10356325,2,1,null);
insert into po_items values(1,10353635,1,1,null);
insert into po_items values(3,10353636,1,1,null);
insert into po_items values(4,10353636,1,1,null);

--insert into payable_status
insert into payable_status values(1,'9/30/2015',10353635,'None','Sent to Supplier','Fully Invoiced','Fully Matched',1);
insert into payable_status values(2,'8/30/2015',10356325,'None','Sent to Supplier','Fully Invoiced','Not Matched',2);
insert into payable_status values(3,'12/01/2015',10353636,'None','Sent to Supplier','Fully Invoiced','Not Matched',3);
insert into payable_status values(4,'12/01/2015',10353636,'None','Sent to Supplier','Fully Invoiced','Not Matched',4);
update po_items set payable_status_id=1 where po_item_id=1;
update po_items set payable_status_id=2 where po_item_id=2;
update po_items set payable_status_id=3 where po_item_id=3;
update po_items set payable_status_id=4 where po_item_id=4;

--insert into invoice_type
insert into invoice_type values(001,'Invoice');

--insert into tax_type
insert into tax_type values(001,'Sales');
insert into tax_type values(002,'Use');

--insert into discount
insert into discount values(1,'0% 30, Net 30',0,30);
insert into discount values(2,'0% 10, Net 10',0,10);

--insert into invoice
insert into invoice values(100779134,10356325,'10/08/2015','11/07/2015',001,2,001);
insert into invoice values(100780781,10353635,'10/07/2015','11/06/2015',001,1,001);
insert into invoice values(100780782,10353636,'12/07/2015','01/06/2016',001,1,001);
insert into invoice values(100780783,10353636,'12/07/2015','01/06/2016',001,1,001);

--insert into invoice_status
insert into invoice_status values('10/07/2015','Payable',100780781);
insert into invoice_status values('10/08/2015','Payable',100779134);
insert into invoice_status values('12/07/2015','Payable',100780782);
insert into invoice_status values('12/07/2015','Payable',100780783);

--insert into payment_type
insert into payment_type values(1,'Unknown');
insert into payment_type values(2,'Employee Card');
insert into payment_type values(3,'Procurement Card');

--insert into payment
insert into payment values(1,2,'12/05/2015',100780782,3.26);
insert into payment values(2,2,'12/05/2015',100780783,326.99);

--insert into ship_items
insert into ship_items values(1,1,100780781,1);
insert into ship_items values(2,1,100780782,3);
insert into ship_items values(3,1,100780783,4);
update invoice_status set pay_status='Paid' where emarket_invoice_id='100780781' or emarket_invoice_id='100780782' or emarket_invoice_id='100780783';

select * from invoice_audit;
select * from payment_audit;
select * from invoice_type;
select * from tax_type;
select * from discount;
select * from invoice;
select * from invoice_status;
select * from payment_type;
select * from payment;
select * from ship_items;
select * from payable_status;
select * from po_items;
select * from po_ap_status;
select * from ap_status;
select * from object_code;
select * from po;
select * from purchase_requisition;
select * from purchaser;
select * from recipient;
select * from employee;
select * from department;
select * from accounts;
select * from vendor;
select * from product;
select * from commodity;
select * from product_size;
select * from size_codes;
select * from vendor_product;
select * from vendor_emp;
select * from zip;

alter table product enable constraint product_size_null;
alter table vendor enable constraint vendor_employee_null;
alter table po_items enable constraint po_items_payable_null;
alter table po enable constraint po_ap_status_null;

spool off;