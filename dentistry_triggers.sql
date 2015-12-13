spool "C:\Users\Tyga\personal_ventures\dental_triggers";

create trigger invoice_delete_audit
before delete on invoice
for each row
begin
insert into invoice_audit values
(:old.emarket_invoice_id,:old.invoice_date);
end;

create trigger payment_insert_audit
before insert on payment
for each row
begin
insert into payment_audit values
(:new.emarket_invoice_id,:new.pay_date,:new.amount_paid);
end;


spool off;