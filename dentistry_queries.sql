spool "C:\Users\Tyga\personal_ventures\dental_queries.sql";

/* show all vendors and the names of the employees that are located in FL */
select distinct description, vendor_emp.first_name, vendor_emp.last_name
from zip, vendor, vendor_emp
where zip.state = 'FL' and zip.zip=vendor.ZIP_CODE and vendor_emp.vendor_emp_id=vendor.vendor_employee;

/* show the amount paid and pay statuses from invoices that occurred in December 2015 */
select PAYMENT.EMARKET_INVOICE_ID, sum(amount_paid) as total, pay_status
from po,PAYMENT,invoice_status,invoice 
where po.po_date >= '12/01/2015' and po.po_number=invoice.po_number and pay_status ='Paid' and
invoice.emarket_invoice_id=PAYMENT.EMARKET_INVOICE_ID and PAYMENT.EMARKET_INVOICE_ID=invoice_status.emarket_invoice_id
group by payment.emarket_invoice_id, pay_status;

/* show the purchase requisitions that did not get fulfilled */
select distinct requisition_number, purpose
from purchase_requisition, po
minus
select distinct po.PURCHASE_REQ_ID, purpose
from PURCHASE_REQUISITION,PO
where po.purchase_req_id=purchase_requisition.requisition_number;

/* show the invoices paid by 'Employee Card' and is over $100 */
select emarket_invoice_id, amount_paid
from payment, payment_type
where amount_paid>100 and payment_type.description='Employee Card';

/* show the employee responsible for the most POs past June 2015*/
with po_count as(select count(po_number)as max_count,purchaser_id from po where po_date>='06/01/2015' group by PURCHASER_ID)
select po_count.purchaser_id, po_count.max_count
from po_count
where rownum<=1
group by po_count.purchaser_id, po_count.max_count
order by po_count.max_count desc;

/* show the recipient and PO number for the POs for which the purchaser was either Huy Ngo or Jane Oh */
with desired_names as (select distinct employee.employee_id from purchaser, employee where first_name='Jane' or first_name='Huy'
and purchaser.employee_id=employee.employee_id)
select distinct recipient_id, po.PO_NUMBER
from po, recipient,purchaser,employee,desired_names
where recipient.employee_id = employee.employee_id and desired_names.employee_id=po.purchaser_id;

spool off;