CREATE SEQUENCE seq_hosted_acc
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  
create or replace function hosted_id () returns varchar as $$
select CONCAT('AGID','-',lpad(''||nextval('seq_hosted_acc'),5,'0'))
$$ language sql

CREATE SEQUENCE seq_order_name
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  
create or replace function order_id () returns varchar as $$
select CONCAT('ORD',to_char(now(),'YYYYMMDD'),'#',lpad(''||nextval('seq_order_name'),4,'0'))
$$ language sql

create table users(
	user_id serial,
	user_name varchar(20),
	user_email varchar(55),
	user_handphone varchar(15),
	user_password varchar(100),
	user_roles varchar(15),
	constraint user_id_pk primary key (user_id)
);

create table hosted(
	hosted_acc varchar(10) default hosted_id(),
	hosted_fullname varchar(55),
	hosted_level varchar(15),
	constraint hosted_acc_pk primary key (hosted_acc)
);

create table address(
	addr_id serial,
	addr_name varchar(255),
	addr_detail varchar(55),
	addr_latitude varchar(200),
	addr_longitude varchar(200),
	addr_user_id integer,
	constraint addr_id_pk primary key (addr_id),
	foreign key (addr_user_id) references users (user_id) on update cascade on delete cascade
);

create table houses (
	house_id serial,
	house_name varchar(150),
	house_title varchar(150),
	house_ratting integer,
	house_bedrooms integer,
	house_occupied integer,
	house_beds integer,
	house_baths integer,
	house_address varchar(255),
	house_province varchar(55),
	house_city varchar(55),
	house_country varchar(55),
	house_latitude varchar(255),
	house_longitude varchar(255),
	house_offer varchar(255),
	house_approval boolean,
	house_hosted_account varchar(10),
	constraint house_id_pk primary key (house_id),
	foreign key (house_hosted_account) references hosted (hosted_acc) on update cascade on delete cascade
);

create table house_images (
	hoim_id serial,
	hoim_url_name varchar(255),
	hoim_filesize integer,
	hoim_filetype varchar(15),
	hoim_host_id integer,
	constraint hoim_id primary key (hoim_id),
	foreign key (hoim_host_id) references houses (house_id) on delete cascade on update cascade
);

create table houses_reviews (
	hore_id serial,
	hore_comments varchar(255),
	hore_ratting integer,
	hore_user_id integer,
	hore_host_id integer,
	constraint hore_id_pk primary key (hore_id),
	foreign key (hore_user_id) references users (user_id) on delete cascade on update cascade,
	foreign key (hore_host_id) references houses (house_id) on delete cascade on update cascade
);

create table houses_bedroom(
	hobed_id serial,
	hobed_name varchar(150),
	hobed_price numeric(15,2),
	hobed_service_fee numeric(15,2),
	constraint hobed_id_pk primary key (hobed_id)
);

create table orders (
	order_name varchar(15) default order_id(),
	order_created date,
	order_subtotal numeric(15,2),
	order_qty integer,
	order_tax numeric(15,2),
	order_discount numeric(15,2),
	order_promo numeric(15,2),
	order_total_price numeric(15,2),
	order_status varchar(15),
	order_payment_type varchar(15),
	order_payment_trx varchar(15),
	order_user_id integer,
	constraint order_name_pk primary key(order_name),
	foreign key (order_user_id) references users (user_id) on delete cascade on update cascade
);

create table houses_reserve_lines (
	hrit_id serial,
	hrit_checkin date,
	hrit_checkout date,
	hrit_adult integer,
	hrit_children integer,
	hrit_infant integer,
	hrit_total_nights integer,
	hrit_price numeric(15,2),
	hrith_service_fee numeric(15,2),
	hrit_subtotal numeric(15,2),
	hrit_host_id integer,
	hrit_hove_id integer,
	hrith_hobed_id integer,
	hrit_order_name varchar(15),
	constraint hrit_id_pk primary key (hrit_id),
	foreign key (hrit_host_id) references houses (house_id) on delete cascade on update cascade,
	foreign key (hrit_hove_id) references houses_reverse (hove_id) on delete cascade on update cascade,
	foreign key (hrith_hobed_id) references houses_bedroom (hobed_id) on delete cascade on update cascade
);

create table houses_reverse (
	hove_id serial,
	hove_created date,
	hove_status varchar(15),
	hove_user_id integer,
	constraint hove_id_pk primary key (hove_id),
	foreign key (hove_user_id) references users (user_id) on delete cascade on update cascade
);