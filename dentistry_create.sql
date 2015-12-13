set pagesize 60;
set linesize 100;
purge recyclebin;
set autocommit on;
spool "C:\Users\Tyga\personal_ventures\dental_creates.sql";
alter session set nls_date_format = 'mm/dd/yyyy';

drop index to_po_cluster_idx;
drop index payment_audit_idx;
drop index payment_date;
drop index employee_name;
drop index employee_phone;
drop index employee_email;
drop index vendor_emp_name;
drop index po_date_idx;
drop index obj_code_desc;
drop index invoice_date_idx;
drop index product_catalog_num;
drop index vendor_product_price;
drop index product_unit_price;
drop index vendor_name;
drop index vendor_phone;
drop index payable_statuses;
drop index payable_status_dates;
drop index taxable_bool;

drop table invoice_audit cascade constraints;
drop table payment_audit cascade constraints;
DROP TABLE invoice_type CASCADE CONSTRAINTS;
DROP TABLE tax_type CASCADE CONSTRAINTS;
DROP TABLE discount CASCADE CONSTRAINTS;
DROP TABLE invoice CASCADE CONSTRAINTS;
DROP TABLE invoice_status CASCADE CONSTRAINTS;
DROP TABLE payment_type CASCADE CONSTRAINTS;
DROP TABLE payment CASCADE CONSTRAINTS;
DROP TABLE ship_items CASCADE CONSTRAINTS;
Drop table payable_status cascade constraints;
Drop table po_items cascade constraints;
Drop table po_ap_status cascade constraints;
Drop table ap_status cascade constraints;
drop table object_code cascade constraints;
Drop table po cascade constraints;
Drop table purchase_requisition cascade constraints;
Drop table purchaser cascade constraints;
Drop table recipient cascade constraints;
Drop table employee cascade constraints;
Drop table department cascade constraints;
Drop table accounts cascade constraints;
drop table vendor cascade constraints;
drop table product cascade constraints;
drop table commodity cascade constraints;
drop table product_size cascade constraints;
drop table size_codes cascade constraints;
drop table vendor_product cascade constraints;
drop table vendor_emp cascade constraints;
drop table zip cascade constraints;
drop cluster to_po including tables;

create cluster to_po(bob number);
create index to_po_cluster_idx on cluster to_po;

create table zip(
zip number(5) constraint zip_pk primary key,
state varchar2(2),
city varchar2(30)
);

--dropped address_type attribute
create table vendor(
supplier_number number constraint vendor_pk primary key,
description varchar2(30) constraint vendor_desc_null not null,
fax number,
phone number constraint vendor_phone_null not null,
address varchar2(30) constraint vendor_address_null not null,
zip_code number(5) constraint vendor_zip_null not null constraint vendor_zip_fk references zip
);

create table commodity(
commodity_code number constraint commodity_pk primary key,
description varchar2(50) constraint commodity_desc_null not null
);

create table product(
supplier_part_aux_id varchar2(20) constraint product_pk1_null unique not null,
manu_part_number varchar2(8) constraint product_pk2_null unique not null,
catalog_number varchar(20) constraint catalog_null not null,
commodity_code number constraint product_commodity_fk references commodity,
description varchar2(150) constraint product_desc_null not null,
unit_price number constraint unit_price_null not null constraint unit_price_zero check(unit_price>0),
constraint product_pk primary key(supplier_part_aux_id, manu_part_number)
);

create table size_codes(
size_code varchar2(2) constraint size_codes_pk primary key
);

create table product_size(
supplier_part_aux_id varchar2(20) constraint supplier_part_fk references product(supplier_part_aux_id) not null,
manu_part_number varchar2(8) constraint manu_part_fk references product(manu_part_number) not null,
size_code varchar2(2) constraint size_code_fk references size_codes,
constraint product_size_pk primary key(supplier_part_aux_id,manu_part_number,size_code)
);

alter table product add (size_code varchar2(2) constraint product_size_fk references size_codes
                                              constraint product_size_null not null);

create table vendor_product(
vendor_product_id number constraint vendor_product_pk primary key,
supplier_number number constraint supplier_num_fk references vendor,
supplier_part_aux_id varchar2(20) constraint supp_part_fk references product(supplier_part_aux_id),
manu_part_number varchar2(8) constraint manu_part_number_fk references product(manu_part_number),
price number constraint vendor_product_price_null not null
             constraint check_price check(price>0)
);

create table vendor_emp(
vendor_emp_id number constraint vendor_emp_pk primary key,
supplier_number number constraint vendor_emp_supplier_no_fk references vendor,
from_invoice_id number constraint invoice_id_null not null,
first_name varchar2(15) constraint vendor_emp_first_null not null,
last_name varchar2(15) constraint vendor_emp_last_null not null
);

alter table vendor add(vendor_employee number constraint vendor_employee_fk references vendor_emp
                                              constraint vendor_employee_null not null);

create table accounts(
account_number number(12) constraint accounts_pk primary key,
address varchar2(30),
zip number(5) constraint account_zip_fk references zip
);

Create table department(
org_id number(10) constraint department_pk primary key,
description varchar2(30),
account_number number(12) references accounts
);

create table employee(
employee_id number(10) constraint employee_id_pk primary key,
first_name varchar2(10) constraint employee_first_nn not null,
last_name varchar2(10) constraint employee_last_nn not null,
phone number constraint employee_phone_nn not null,
email varchar2(30) constraint employee_email_nn not null,
address varchar2(30),
zip_code number(5) constraint employee_zip_fk references zip,
org_id number(10) constraint employee_org_fk references department
);

create table recipient(
employee_id number constraint recipient_pk primary key constraint recipient_fk references employee(employee_id),
delivery_address varchar2(30)
);

create table purchaser(
employee_id number constraint purchaser_pk primary key constraint purchaser_fk references employee(employee_id),
description varchar2(30)
);

create table purchase_requisition(
requisition_number number constraint pur_req_pk primary key,
purpose varchar2(60)
);

create table object_code(
object_code number constraint object_code_pk primary key,
description varchar2(30) constraint object_code_null not null
);

create table po(
po_number number constraint po_pk primary key,
po_date date,
object_code number constraint po_object_code_fk references object_code,
purchaser_id number(10) constraint po_purchaser_fk references employee,
recipient_id number(10) constraint po_recipient_fk references employee,
purchase_req_id number constraint po_pur_req_fk references purchase_requisition
);

Create table ap_status(
ap_status_id number constraint ap_status_pk primary key,
description varchar2(30)
);

Create table po_ap_status(
po_ap_status_id number constraint po_ap_pk primary key,
po_number number constraint po_ap_fk references po,
ap_status_id number constraint ap_status_fk references ap_status
)cluster to_po(po_number);

alter table po add(po_ap_status_id number constraint po_ap_status_fk references po_ap_status
                                          constraint po_ap_status_null not null);

Create table po_items(
po_item_id number(5) constraint po_items_pk primary key,
po_number number constraint po_num_item_fk references po,
quantity number constraint quantity_null not null constraint quantity_zero check(quantity>0),
taxable number
)cluster to_po(po_number);

create table payable_status(
payable_status_id number(5) constraint payable_status_pk primary key,
status_date date constraint payable_status_date_null not null,
po_number number constraint payable_status_po_fk references po,
receiving_status varchar2(30) constraint receiving_status_null not null
                             constraint receiving_status_opts check(receiving_status = 'None' or receiving_status='Received'),
supplier_status varchar2(30) constraint supplier_status_null not null
                            constraint supplier_status_opts check(supplier_status='Sent to Supplier' or supplier_status='Shipped'), 
invoicing varchar2(30) constraint invoicing_null not null
                       constraint invoicing_opts check(invoicing='Fully Invoiced'),
matching varchar2(30) constraint matching_null not null
                      constraint matching_opts check(matching='Fully Matched' or matching='Not Matched'),
po_item_id number(5) constraint payable_po_item_fk references po_items
)cluster to_po(po_number);

alter table po_items add(payable_status_id number constraint po_items_payable_fk references payable_status
                                                  constraint po_items_payable_null not null);

CREATE TABLE invoice_type (
invoice_type_id     number(3)       CONSTRAINT invoice_type_PK PRIMARY KEY,
description         varchar2(20)    CONSTRAINT invoice_type_desc_NN NOT NULL);

CREATE TABLE tax_type (
tax_type_id         number(3)       CONSTRAINT tax_type_PK PRIMARY KEY,
description         varchar(10)     CONSTRAINT tax_type_desc_NN NOT NULL
);

CREATE TABLE discount (
discount_id         number(3)       CONSTRAINT discount_PK PRIMARY KEY,
terms               varchar2(20)    CONSTRAINT discount_desc_NN NOT NULL,
percentage          number(5,3)     CONSTRAINT discount_percentage_NN NOT NULL,
timeframe           number(5)      CONSTRAINT discount_timeframe_NN NOT NULL
);

CREATE TABLE invoice (
eMarket_invoice_id  number(10)      CONSTRAINT invoice_PK PRIMARY KEY,
po_number           number          constraint po_num_fk references po,
invoice_date        date            CONSTRAINT invoide_date_NN NOT NULL,
due_date            date            constraint invoice_due_NN not null,
tax_type_id         number(3,2)     CONSTRAINT invoice_tax_FK references tax_type
                                    CONSTRAINT invoice_tax_NN NOT NULL,
discount_id         number(3,2)     CONSTRAINT invoice_discount_FK references discount
                                    CONSTRAINT invoice_discount_NN NOT NULL,
invoice_type_id     number(3)       CONSTRAINT invoice_itype_FK references invoice_type
                                    CONSTRAINT invoice_itype_NN NOT NULL
)cluster to_po(po_number);

CREATE TABLE invoice_status (
status_date        date,
pay_status         varchar2(20),
eMarket_invoice_id number(10)       CONSTRAINT invoice_status_invoice_FK references invoice
                                    CONSTRAINT invoice_status_invoice_NN NOT NULL,
CONSTRAINT invoice_status_PK PRIMARY KEY (status_date, pay_status,eMarket_invoice_id)
);

CREATE TABLE payment_type(
payment_type_id     number(3)       CONSTRAINT payment_type_PK PRIMARY KEY,
description         varchar2(20)    CONSTRAINT payment_type_desc_NN NOT NULL
);

CREATE TABLE payment(
payment_id number constraint payment_pk primary key,
payment_type_id     number(3)       CONSTRAINT payment_ptype_FK references payment_type
                                    CONSTRAINT payment_ptype_NN NOT NULL,
pay_date            date,
eMarket_invoice_id  number(10)      CONSTRAINT payment_invoice_FK references invoice
                                    CONSTRAINT payment_invoice_NN NOT NULL,
amount_paid number constraint amount_paid_null not null constraint amount_paid_zero check(amount_paid>0)
);

CREATE TABLE ship_items(
ship_items_id       number(5)       CONSTRAINT ship_PK PRIMARY KEY,
quantity            number(20)      CONSTRAINT ship_quantity_NN NOT NULL,
eMarket_invoice_id  number(10)      CONSTRAINT ship_invoice_FK references invoice
                                    CONSTRAINT ship_invoice_NN NOT NULL,
po_item_id  number(10)              CONSTRAINT ship_poitem_FK references po_items
                                    CONSTRAINT ship_poitem_NN NOT NULL
);

create table invoice_audit(
invoice_id number constraint invoice_audit_pk primary key,
delete_date date constraint invoice_audit_null not null
);

create table payment_audit(
invoice_id number constraint payment_audit_null not null,
add_date date constraint payment_date_null not null,
amount number constraint amount_null not null,
constraint payment_audit_pk primary key(invoice_id,add_date)
);

create index employee_name on employee(first_name,last_name);
create index employee_phone on employee(phone);
create index employee_email on employee(email);
create index vendor_emp_name on vendor_emp(first_name,last_name);
create index po_date_idx on po(po_date);
create index obj_code_desc on object_code(description);
create index invoice_date_idx on invoice(invoice_date,due_date);
create index product_catalog_num on product(catalog_number);
create index vendor_product_price on vendor_product(price);
create index product_unit_price on product(unit_price);
create index vendor_name on vendor(description);
create index vendor_phone on vendor(phone);
create index payment_date on payment(pay_date);
create index payable_statuses on payable_status(invoicing,matching,receiving_status,supplier_status);
create index payable_status_dates on payable_status(status_date);
create index taxable_bool on po_items(taxable);
create index payment_audit_idx on payment_audit(invoice_id,add_date,amount);

spool off;