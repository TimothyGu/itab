
alter table student add diet varchar(31);
alter table chapter_judge add diet varchar(31);

create index tourn on school(tourn);

alter table pool add standby_timeslot int;
alter table pool add tourn int;

